# Complete Setup Guide

This guide walks you through setting up your own AI wellness call system from scratch.

## Prerequisites

### 1. Install OpenClaw
```bash
npm install -g openclaw
```

### 2. Service Accounts Needed

| Service | Purpose | Cost | Signup Link |
|---------|---------|------|-------------|
| **Twilio** | Phone calls & PSTN | ~$0.07/call | [twilio.com](https://twilio.com) |
| **OpenAI** | Speech-to-text | ~$0.03/call | [platform.openai.com](https://platform.openai.com) |
| **Anthropic** | AI responses | ~$0.15/call | [console.anthropic.com](https://console.anthropic.com) |
| **ElevenLabs** | Text-to-speech | ~$0.30/call | [elevenlabs.io](https://elevenlabs.io) |
| **ngrok** (optional) | Webhooks | Free tier OK | [ngrok.com](https://ngrok.com) |

## Step-by-Step Setup

### 1. Clone & Configure

```bash
git clone https://github.com/rahimrehmat/wellness-call-demo.git
cd wellness-call-demo

# Copy environment template
cp config/.env.example .env

# Edit .env with your API keys
nano .env
```

### 2. Twilio Setup

1. **Buy a phone number**: Console → Phone Numbers → Manage → Buy a number
2. **Get credentials**: Console → Account → API keys & tokens
3. **Add to .env**:
   ```bash
   TWILIO_ACCOUNT_SID=ACxxxxx...
   TWILIO_AUTH_TOKEN=xxxxx...
   WELLNESS_FROM_NUMBER=+1234567890  # Your Twilio number
   ```

### 3. AI Service Setup

**OpenAI:**
```bash
# Get API key from platform.openai.com
OPENAI_API_KEY=sk-xxxxx...
```

**Anthropic:**
```bash  
# Get API key from console.anthropic.com
ANTHROPIC_API_KEY=sk-ant-xxxxx...
```

**ElevenLabs:**
```bash
# Get API key from elevenlabs.io
ELEVENLABS_API_KEY=xxxxx...
```

### 4. OpenClaw Configuration

```bash
# Copy the example config
cp config/openclaw.example.yaml ~/.openclaw/openclaw.yaml

# Edit with your credentials
nano ~/.openclaw/openclaw.yaml
```

**Key sections to update:**
```yaml
plugins:
  - name: voice-call
    config:
      provider: twilio
      accountSid: "${TWILIO_ACCOUNT_SID}"
      authToken: "${TWILIO_AUTH_TOKEN}"  
      fromNumber: "${WELLNESS_FROM_NUMBER}"
      
      # TTS Settings
      tts:
        elevenlabs:
          apiKey: "${ELEVENLABS_API_KEY}"
          voiceId: "21m00Tcm4TlvDq8ikWAM"  # Rachel
          modelId: "eleven_flash_v2_5"
      
      # STT Settings
      streaming:
        enabled: true
        openaiApiKey: "${OPENAI_API_KEY}"
      
      # Response Model
      responseModel: "anthropic/claude-sonnet-4-20250514"
```

### 5. Patient Profile Setup

```bash
# Copy patient template
cp templates/patient-profile.md ~/.openclaw/workspace/MEMORY.md

# Customize for your family member
nano ~/.openclaw/workspace/MEMORY.md
```

**Update these sections:**
- Patient's name, age, and health conditions
- Phone number
- Best time to call
- Key health questions to ask
- Emergency contact information

### 6. Test the System

```bash
# Start OpenClaw
openclaw gateway start

# Test with your own number first
./scripts/test-call.sh +1234567890 "This is a test call"

# Check logs for any errors
openclaw logs
```

### 7. Make Your First Wellness Call

Send a message to your OpenClaw assistant:
```
Call mom for a wellness check
```

Or use the tool directly:
```bash
openclaw tool voice_call '{
  "action": "initiate_call", 
  "to": "+1234567890",
  "message": "Hello! This is Sarah, the community health nurse..."
}'
```

## Troubleshooting

### Common Issues

**"Call failed to connect"**
- Check your Twilio balance
- Verify the phone number format (+1234567890)
- Check if international calling is enabled

**"AI response timeout"**
- Check your Anthropic API key
- Verify you have API credits
- Try a simpler test message

**"TTS generation failed"**  
- Check ElevenLabs API key
- Verify voice ID is correct
- Try OpenAI TTS as fallback

**"Webhook not receiving calls"**
- Ensure ngrok is running and public URL is set
- Check firewall settings
- Verify webhook URL in Twilio console

### Testing Individual Components

```bash
# Test Twilio connection
curl -X POST "https://api.twilio.com/2010-04-01/Accounts/ACxxxx/Calls.json" \
  -d "To=+1234567890" \
  -d "From=+1234567890" \
  -d "Url=http://demo.twilio.com/docs/voice.xml" \
  -u ACxxxx:your_auth_token

# Test OpenAI API  
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer sk-xxxxx"

# Test Anthropic API
curl https://api.anthropic.com/v1/messages \
  -H "Authorization: Bearer sk-ant-xxxxx"

# Test ElevenLabs API
curl https://api.elevenlabs.io/v1/voices \
  -H "xi-api-key: xxxxx"
```

## Security Considerations

- **Never commit API keys** to git
- **Use environment variables** for all credentials  
- **Enable webhook signature verification** in production
- **Consider call recording consent** if storing transcripts
- **Limit international calling** to prevent abuse

## Scaling Up

### Multiple Patients
- Create separate patient profiles in `patients/` directory
- Use phone number → patient mapping
- Customize personas per patient

### Scheduled Calls
```bash
# Add to crontab for daily 2 PM calls
0 14 * * * openclaw tool voice_call '{"action":"initiate_call","to":"+1234567890"}'
```

### Call Analytics
- Log call outcomes to database
- Track health trends over time
- Alert on concerning responses
- Generate weekly summaries

## Next Steps

1. **Test thoroughly** with family member consent
2. **Set up monitoring** for failed calls
3. **Create backup plans** if system is down
4. **Train family** on how to interpret alerts
5. **Consider professional review** of health questions

## Support

- **Issues**: [GitHub Issues](https://github.com/rahimrehmat/wellness-call-demo/issues)
- **Discord**: [OpenClaw Community](https://discord.com/invite/clawd)  
- **Docs**: [OpenClaw Documentation](https://docs.openclaw.ai)

---

**⚠️ Important**: This system is for wellness monitoring only, not medical diagnosis. Always consult healthcare professionals for medical concerns.