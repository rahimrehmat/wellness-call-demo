#!/bin/bash
# Service connectivity checker for wellness call system

set -e

echo "🔍 Checking Wellness Call System Services..."
echo "================================================"

# Load environment if available
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

ERRORS=0

# Check OpenClaw status
echo -n "🤖 OpenClaw Gateway: "
if pgrep -f "openclaw" > /dev/null; then
    echo "✅ Running"
else
    echo "❌ Not running (start with: openclaw gateway start)"
    ((ERRORS++))
fi

# Check Twilio
echo -n "📞 Twilio API: "
if [ -z "$TWILIO_ACCOUNT_SID" ] || [ -z "$TWILIO_AUTH_TOKEN" ]; then
    echo "❌ Missing credentials (TWILIO_ACCOUNT_SID or TWILIO_AUTH_TOKEN)"
    ((ERRORS++))
else
    TWILIO_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -u "$TWILIO_ACCOUNT_SID:$TWILIO_AUTH_TOKEN" \
        "https://api.twilio.com/2010-04-01/Accounts/$TWILIO_ACCOUNT_SID.json" || echo "000")
    
    if [ "$TWILIO_RESPONSE" = "200" ]; then
        echo "✅ Connected"
    else
        echo "❌ Failed (HTTP $TWILIO_RESPONSE) - Check credentials"
        ((ERRORS++))
    fi
fi

# Check OpenAI
echo -n "🧠 OpenAI API: "
if [ -z "$OPENAI_API_KEY" ]; then
    echo "❌ Missing OPENAI_API_KEY"
    ((ERRORS++))
else
    OPENAI_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        "https://api.openai.com/v1/models" || echo "000")
    
    if [ "$OPENAI_RESPONSE" = "200" ]; then
        echo "✅ Connected"
    else
        echo "❌ Failed (HTTP $OPENAI_RESPONSE) - Check API key"
        ((ERRORS++))
    fi
fi

# Check Anthropic
echo -n "🧩 Anthropic API: "
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "❌ Missing ANTHROPIC_API_KEY"
    ((ERRORS++))
else
    ANTHROPIC_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "x-api-key: $ANTHROPIC_API_KEY" \
        -H "anthropic-version: 2023-06-01" \
        "https://api.anthropic.com/v1/messages" \
        -d '{"model":"claude-3-haiku-20240307","max_tokens":1,"messages":[{"role":"user","content":"hi"}]}' || echo "000")
    
    if [ "$ANTHROPIC_RESPONSE" = "200" ]; then
        echo "✅ Connected"
    else
        echo "❌ Failed (HTTP $ANTHROPIC_RESPONSE) - Check API key"
        ((ERRORS++))
    fi
fi

# Check ElevenLabs
echo -n "🎙️ ElevenLabs API: "
if [ -z "$ELEVENLABS_API_KEY" ]; then
    echo "❌ Missing ELEVENLABS_API_KEY"
    ((ERRORS++))
else
    ELEVENLABS_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "xi-api-key: $ELEVENLABS_API_KEY" \
        "https://api.elevenlabs.io/v1/voices" || echo "000")
    
    if [ "$ELEVENLABS_RESPONSE" = "200" ]; then
        echo "✅ Connected"
    else
        echo "❌ Failed (HTTP $ELEVENLABS_RESPONSE) - Check API key"
        ((ERRORS++))
    fi
fi

# Check ngrok (optional)
echo -n "🌐 ngrok tunnel: "
if command -v ngrok &> /dev/null; then
    if pgrep -f "ngrok" > /dev/null; then
        echo "✅ Running"
    else
        echo "⚠️ Not running (may be needed for webhooks)"
    fi
else
    echo "⚠️ Not installed (may be needed for webhooks)"
fi

# Check configuration files
echo -n "⚙️ OpenClaw config: "
if [ -f ~/.openclaw/openclaw.yaml ]; then
    echo "✅ Found"
else
    echo "❌ Missing (~/.openclaw/openclaw.yaml)"
    ((ERRORS++))
fi

echo -n "👤 Patient profile: "
if [ -f ~/.openclaw/workspace/MEMORY.md ]; then
    echo "✅ Found"
else
    echo "❌ Missing (~/.openclaw/workspace/MEMORY.md)"
    ((ERRORS++))
fi

# Summary
echo "================================================"
if [ $ERRORS -eq 0 ]; then
    echo "✅ All systems operational! Ready to make calls."
    echo
    echo "🚀 Test your system with:"
    echo "   ./scripts/test-call.sh +1234567890"
else
    echo "❌ Found $ERRORS issue(s). Fix them before making calls."
    echo
    echo "📖 See docs/setup-guide.md for help"
fi

exit $ERRORS