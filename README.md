# AI Wellness Call System

> 🤖📞 An AI-powered voice calling system for elderly wellness checks using OpenClaw, Twilio, and ElevenLabs.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

This project demonstrates how to build an AI assistant that makes outbound phone calls to check on elderly family members. The AI introduces itself as a community health nurse, asks about specific health conditions, and reports back if anything seems concerning.

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Family    │───▶│     AI      │───▶│   Phone     │───▶│   Elderly   │
│   Member    │    │  Assistant  │    │   Network   │    │   Parent    │
│             │    │  "Sarah"    │    │  (Twilio)   │    │             │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
     Telegram         OpenClaw            PSTN            Regular Phone
```

## Features

- **📞 Real Phone Calls** — Works on any phone (landline or mobile), no app needed
- **🗣️ Natural Voice** — ElevenLabs provides warm, human-like speech
- **🧠 Context-Aware** — Claude AI understands health context and asks relevant follow-ups
- **👩‍⚕️ Caring Persona** — Introduces as a community health nurse
- **⚡ Real-Time** — Live conversation with ~3-5 second response time
- **📱 Easy Trigger** — Start calls via Telegram, SMS, or any chat interface

## Architecture

```
┌────────────────────────────────────────────────────────────────────────────┐
│                        REAL-TIME CONVERSATION LOOP                          │
└────────────────────────────────────────────────────────────────────────────┘

 Elderly        Phone         Twilio        OpenClaw       OpenAI        Claude
 Person        Network                      Gateway       Realtime
    │             │              │              │            │             │
    │  Speaks     │              │              │            │             │
    │────────────▶│─────────────▶│─────────────▶│───────────▶│             │
    │             │   Audio      │  WebSocket   │   STT      │             │
    │             │              │              │            │             │
    │             │              │              │  Text      │             │
    │             │              │              │◀───────────│             │
    │             │              │              │                          │
    │             │              │              │─────────────────────────▶│
    │             │              │              │         Process + Reply  │
    │             │              │              │◀─────────────────────────│
    │             │              │              │                          │
    │             │              │              │────▶ ElevenLabs TTS      │
    │             │              │              │◀──── Audio               │
    │             │              │              │            │             │
    │  Hears AI   │◀─────────────│◀─────────────│            │             │
    │◀────────────│              │              │            │             │
    │             │              │              │            │             │
```

## Tech Stack

| Component | Service | Purpose |
|-----------|---------|---------|
| Orchestration | [OpenClaw](https://github.com/openclaw/openclaw) | AI assistant framework |
| Telephony | [Twilio](https://www.twilio.com/) | Phone calls & PSTN gateway |
| Speech-to-Text | [OpenAI Realtime](https://platform.openai.com/) | Convert speech to text |
| Language Model | [Anthropic Claude](https://www.anthropic.com/) | Generate contextual responses |
| Text-to-Speech | [ElevenLabs](https://elevenlabs.io/) | Natural voice synthesis |
| Tunnel | [ngrok](https://ngrok.com/) | Expose webhooks to internet |

## Quick Start

### Prerequisites

- Node.js 18+
- [OpenClaw](https://github.com/openclaw/openclaw) installed
- Accounts with: Twilio, OpenAI, Anthropic, ElevenLabs
- ngrok (free tier works)

### 1. Clone this repository

```bash
git clone https://github.com/rahimrehmat/wellness-call-demo.git
cd wellness-call-demo
```

### 2. Configure OpenClaw

Copy the example config and add your credentials:

```bash
cp config/openclaw.example.yaml ~/.openclaw/openclaw.yaml
```

Edit the config with your API keys (see [Configuration](#configuration)).

### 3. Set up the patient profile

Copy the patient template and customize:

```bash
cp templates/patient-profile.md ~/.openclaw/workspace/MEMORY.md
```

Edit with your family member's details.

### 4. Start OpenClaw

```bash
openclaw gateway start
```

### 5. Make a test call

Send a message to your OpenClaw assistant:
```
Call mom for a wellness check
```

## Configuration

### OpenClaw Config (`openclaw.yaml`)

```yaml
plugins:
  - name: voice-call
    config:
      provider: twilio
      accountSid: "${TWILIO_ACCOUNT_SID}"
      authToken: "${TWILIO_AUTH_TOKEN}"
      fromNumber: "+1XXXXXXXXXX"  # Your Twilio number
      
      tunnelProvider: ngrok
      
      sttProvider: openai-realtime
      responseModel: anthropic/claude-sonnet-4-20250514
      
      ttsProvider: elevenlabs
      ttsVoice: "21m00Tcm4TlvDq8ikWAM"  # Rachel voice
      ttsModel: "eleven_flash_v2_5"
```

### Environment Variables

```bash
export TWILIO_ACCOUNT_SID="ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
export TWILIO_AUTH_TOKEN="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export ELEVENLABS_API_KEY="..."
```

## Customization

### Changing the Persona

Edit `templates/persona.md` to customize how the AI introduces itself and conducts the call. The default persona is a caring community health nurse named "Sarah".

### Adding Health Questions

Update the patient profile in `MEMORY.md` with specific health conditions to ask about:

```markdown
- **Key health questions:** 
  - Ask about blood pressure
  - Any dizziness or falls?
  - Taking medications regularly?
```

### Changing the Voice

ElevenLabs offers many voices. Update `ttsVoice` in your config:

| Voice | ID | Description |
|-------|-----|-------------|
| Rachel | `21m00Tcm4TlvDq8ikWAM` | Warm, friendly (default) |
| Adam | `pNInz6obpgDQGcFmaJgB` | Calm, professional |
| Bella | `EXAVITQu4vr4xnSDxMaL` | Soft, gentle |

## Cost Estimate

| Service | Rate | Per 5-min call |
|---------|------|----------------|
| Twilio Voice | $0.014/min | $0.07 |
| OpenAI Realtime STT | $0.006/min | $0.03 |
| Anthropic Claude | ~$0.003/1K tokens | ~$0.15 |
| ElevenLabs TTS | $0.30/1K chars | ~$0.30 |
| **Total** | | **~$0.55/call** |

Monthly cost for daily calls: ~$16.50

## Documentation

- [Full Architecture Documentation](docs/architecture.md) — Detailed system design with diagrams
- [Persona Template](templates/persona.md) — How to craft the AI's personality
- [Patient Profile Template](templates/patient-profile.md) — Structure for storing patient context
- [Example Conversations](examples/conversation-flows.md) — Sample call transcripts

## Limitations

- **Latency**: 3-5 seconds between responses (noticeable but acceptable)
- **No IVR Navigation**: Can't navigate automated phone menus (no DTMF)
- **Audio Quality**: Dependent on recipient's phone quality
- **No Transcripts**: Call content isn't saved (privacy feature, but limits review)

## Future Ideas

- [ ] Call transcripts with consent
- [ ] Scheduled automatic calls
- [ ] Concerning response detection & alerts
- [ ] Multi-language support
- [ ] Medication reminders
- [ ] Integration with health devices

## Use Cases

Beyond elderly care, this architecture works for:

- **Appointment reminders** — Doctor, dentist, etc.
- **Medication adherence** — Daily check-ins
- **Mental health check-ins** — Supportive daily calls
- **Customer service** — Outbound support calls
- **Survey collection** — Voice-based surveys

## Contributing

Contributions welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

## License

MIT License — see [LICENSE](LICENSE) for details.

## Acknowledgments

- [OpenClaw](https://github.com/openclaw/openclaw) for the AI assistant framework
- [Twilio](https://www.twilio.com/) for telephony infrastructure
- [ElevenLabs](https://elevenlabs.io/) for amazing voice synthesis
- [Anthropic](https://www.anthropic.com/) for Claude's empathetic responses

---

**Built with ❤️ for keeping families connected**

*Questions? Open an issue or reach out on Twitter [@rahim_rehmat](https://twitter.com/your_handle)*
