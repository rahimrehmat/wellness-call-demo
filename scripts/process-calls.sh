#!/bin/bash
# Wellness Call Processor
# Pre-filters call data and outputs JSON for AI summarization
#
# ⚠️  IMPORTANT: Update phone numbers below with your actual values
# ⚠️  Do NOT commit real phone numbers to public repositories

CALLS_FILE="$HOME/.openclaw/voice-calls/calls.jsonl"
PROCESSED_FILE="$HOME/.openclaw/workspace/wellness-calls/processed-calls.json"
TRANSCRIPTS_DIR="$HOME/.openclaw/workspace/wellness-calls/transcripts"

# Patient's phone number (only send Telegram summaries for this number)
MOM_PHONE="+1555PATIENT"  # Replace with actual patient number
# Test number (treat as wellness for testing)
TEST_WELLNESS="+1555TESTING"  # Replace with your test number

# Ensure directories exist
mkdir -p "$TRANSCRIPTS_DIR"

# Get list of already processed call IDs
if [ -f "$PROCESSED_FILE" ]; then
    PROCESSED_IDS=$(jq -r '.processedCallIds[]' "$PROCESSED_FILE" 2>/dev/null | tr '\n' '|')
else
    PROCESSED_IDS=""
fi

# Find completed conversation-mode calls
# Get the LAST record for each callId (most recent state)
UNPROCESSED=$(grep '"state":"completed"' "$CALLS_FILE" 2>/dev/null | \
    grep '"mode":"conversation"' | \
    jq -s 'group_by(.callId) | map(last)' | \
    jq --arg processed "$PROCESSED_IDS" '
        [.[] | select(.callId as $id | ($processed | split("|") | index($id) | not))]
    ')

COUNT=$(echo "$UNPROCESSED" | jq 'length')

if [ "$COUNT" -eq "0" ] || [ "$COUNT" = "null" ]; then
    echo "NO_NEW_CALLS"
    exit 0
fi

echo "FOUND_CALLS:$COUNT"

# Process each unprocessed call
echo "$UNPROCESSED" | jq -c '.[]' | while read -r call; do
    CALL_ID=$(echo "$call" | jq -r '.callId')
    START_TS=$(echo "$call" | jq -r '.startedAt')
    END_TS=$(echo "$call" | jq -r '.endedAt')
    ANSWERED_TS=$(echo "$call" | jq -r '.answeredAt // .startedAt')
    
    # Calculate duration
    DURATION_SEC=$(( (END_TS - ANSWERED_TS) / 1000 ))
    DURATION_MIN=$((DURATION_SEC / 60))
    DURATION_REM=$((DURATION_SEC % 60))
    
    # Format date for filename (from startedAt)
    FILE_DATE=$(date -r $((START_TS / 1000)) "+%Y-%m-%d-%H%M" 2>/dev/null || date -d "@$((START_TS / 1000))" "+%Y-%m-%d-%H%M")
    DISPLAY_DATE=$(date -r $((START_TS / 1000)) "+%Y-%m-%d %H:%M" 2>/dev/null || date -d "@$((START_TS / 1000))" "+%Y-%m-%d %H:%M")
    
    # Extract clean transcript (skip system prompt - first bot entry if >500 chars)
    TRANSCRIPT=$(echo "$call" | jq -r '
        .transcript | 
        if .[0].speaker == "bot" and (.[0].text | length) > 500 then .[1:] else . end |
        .[] | 
        (if .speaker == "bot" then "**🤖 Sarah:** " else "**👵 Patient:** " end) + .text
    ')
    
    # Create markdown file
    TRANSCRIPT_FILE="$TRANSCRIPTS_DIR/${FILE_DATE}.md"
    cat > "$TRANSCRIPT_FILE" << EOF
# Wellness Call Transcript

**Date:** $DISPLAY_DATE PST
**Duration:** ${DURATION_MIN} minutes ${DURATION_REM} seconds
**Call ID:** $CALL_ID

---

## Conversation

$TRANSCRIPT

---

*Transcript generated automatically by Wellness Call System*
EOF

    # Check if this is a call to mom or a test call
    TO_NUMBER=$(echo "$call" | jq -r '.to')
    if [ "$TO_NUMBER" = "$MOM_PHONE" ] || [ "$TO_NUMBER" = "$TEST_WELLNESS" ]; then
        CALL_TYPE="WELLNESS"
    else
        CALL_TYPE="TEST"
    fi
    
    # Output summary data for AI processing
    echo "---CALL_DATA---"
    echo "CALL_ID:$CALL_ID"
    echo "CALL_TYPE:$CALL_TYPE"
    echo "DATE:$DISPLAY_DATE"
    echo "DURATION:${DURATION_MIN}m ${DURATION_REM}s"
    echo "TRANSCRIPT_FILE:$TRANSCRIPT_FILE"
    
    # Only include patient responses for wellness calls (for summary)
    if [ "$CALL_TYPE" = "WELLNESS" ]; then
        PATIENT_RESPONSES=$(echo "$call" | jq -r '.transcript[] | select(.speaker == "user") | .text' | head -c 2000)
        echo "PATIENT_RESPONSES:$PATIENT_RESPONSES"
    fi
    echo "---END_CALL---"
done
