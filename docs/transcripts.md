# Call Transcripts & Logging

> Automatic call transcription and post-call summary delivery.

**Version:** 1.0  
**Added:** February 2026

---

## Overview

The wellness call system automatically captures transcripts of all calls and generates AI-powered summaries delivered to the family member via Telegram.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        POST-CALL PROCESSING FLOW                             │
└─────────────────────────────────────────────────────────────────────────────┘

  Call Ends          Cron Job           Processor          Telegram
      │                  │                  │                  │
      │   Completed      │                  │                  │
      │─────────────────▶│                  │                  │
      │                  │  Check for new   │                  │
      │                  │  completed calls │                  │
      │                  │─────────────────▶│                  │
      │                  │                  │                  │
      │                  │                  │ Extract          │
      │                  │                  │ transcript       │
      │                  │                  │                  │
      │                  │                  │ Save markdown    │
      │                  │                  │ file             │
      │                  │                  │                  │
      │                  │                  │ Generate         │
      │                  │                  │ summary          │
      │                  │                  │                  │
      │                  │                  │ Send to          │
      │                  │                  │ Telegram         │
      │                  │                  │─────────────────▶│
      │                  │                  │                  │
```

---

## Components

### 1. Call Data Storage

OpenClaw's voice-call plugin automatically stores call records in JSONL format:

```
~/.openclaw/voice-calls/calls.jsonl
```

Each call record includes:
- Call ID and timestamps
- Direction (inbound/outbound)
- Phone numbers (from/to)
- Call state and end reason
- **Full transcript** with speaker labels and timestamps

### 2. Transcript Processor

A shell script pre-processes call data efficiently:

```
~/.openclaw/workspace/wellness-calls/process-calls.sh
```

**What it does:**
- Reads completed calls from JSONL
- Filters out already-processed calls
- Extracts clean transcripts (removes system prompts)
- Calculates call duration
- Outputs structured data for summary generation

### 3. Processed Calls Tracker

Prevents duplicate processing:

```
~/.openclaw/workspace/wellness-calls/processed-calls.json
```

```json
{
  "processedCallIds": ["uuid-1", "uuid-2", ...],
  "lastProcessedAt": "2026-02-02T18:00:00Z"
}
```

### 4. Transcript Files

Saved as markdown for easy reading:

```
~/.openclaw/workspace/wellness-calls/transcripts/
├── 2026-02-01-1530.md
├── 2026-02-01-1845.md
└── 2026-02-02-1426.md
```

**Filename format:** `YYYY-MM-DD-HHmm.md` (based on call start time)

---

## Transcript Format

```markdown
# Wellness Call Transcript

**Date:** 2026-02-01 15:30 PST
**Duration:** 4 minutes 23 seconds
**Call ID:** abc123-def456-...

---

## Conversation

**👵 Patient:** Hello?

**🤖 Sarah:** Hello! It's Sarah calling for your wellness check...

**👵 Patient:** Oh hi Sarah, I'm doing well today...

---

*Transcript generated automatically by Wellness Call System*
```

---

## Telegram Summary Format

After each wellness call, a summary is automatically sent:

```
📞 **Wellness Call Summary**

**Date:** Feb 1, 2026 @ 3:30 PM
**Duration:** 4 min 23 sec

**Patient Status:** ✅ Good
- Feeling well, no pain
- Energy levels normal
- Blood test scheduled for next week

**Key Topics Discussed:**
- General wellbeing
- Kidney health monitoring (GFR)
- Medication compliance

**Mood:** Positive and engaged

**Follow-up Notes:**
- Ask about blood test results next call
```

---

## Configuration

### Cron Job

The processor runs automatically via OpenClaw cron:

```yaml
name: wellness-call-processor
schedule:
  kind: every
  everyMs: 300000  # Every 5 minutes
sessionTarget: isolated
payload:
  kind: agentTurn
  message: "Run the wellness call processor..."
```

### Phone Number Filtering

By default, only calls to specified numbers generate Telegram summaries:

```bash
# In process-calls.sh
MOM_PHONE="+1XXXXXXXXXX"  # Primary wellness number
```

Test calls are transcribed but don't trigger notifications.

---

## Privacy Considerations

### Data Stored Locally
- All transcripts stored on local machine only
- No cloud storage of call content
- Call logs in OpenClaw's data directory

### What's NOT Stored
- No audio recordings (only text transcripts)
- Phone numbers can be redacted in transcript files
- No automatic cloud backup

### Recommendations
- Regularly review and clean old transcripts
- Consider encrypting the transcripts directory
- Get patient consent for transcription

---

## Troubleshooting

### Transcripts not appearing

1. Check if calls are completing successfully:
   ```bash
   grep '"state":"completed"' ~/.openclaw/voice-calls/calls.jsonl | tail -5
   ```

2. Verify the processor script works:
   ```bash
   ~/.openclaw/workspace/wellness-calls/process-calls.sh
   ```

3. Check processed calls tracker:
   ```bash
   cat ~/.openclaw/workspace/wellness-calls/processed-calls.json
   ```

### Summary not sent to Telegram

1. Verify call is to a "wellness" number (not test)
2. Check cron job is running: `openclaw status`
3. Check cron logs in OpenClaw dashboard

### Large calls.jsonl file

The JSONL file grows over time. To manage:

```bash
# Archive old entries (keep last 1000 lines)
tail -1000 ~/.openclaw/voice-calls/calls.jsonl > calls-trimmed.jsonl
mv calls-trimmed.jsonl ~/.openclaw/voice-calls/calls.jsonl
```

---

## Future Enhancements

- [ ] Searchable transcript archive
- [ ] Sentiment analysis on patient responses
- [ ] Automatic concerning response detection
- [ ] Weekly/monthly call summary reports
- [ ] Optional audio recording with consent

---

*Part of the AI Wellness Call System*
