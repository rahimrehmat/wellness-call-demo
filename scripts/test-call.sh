#!/bin/bash
# Quick test call script for wellness check system
#
# ⚠️  IMPORTANT: Set TEST_PHONE_NUMBER environment variable with your real test number
# ⚠️  The default +1555TESTING is a placeholder - replace with actual number

set -e

# Configuration  
DEFAULT_TEST_NUMBER="${TEST_PHONE_NUMBER:-+1555TESTING}"  # ⚠️ Replace with real number
DEFAULT_MESSAGE="Hello! This is a test call from the wellness check system. Just making sure everything is working properly."

# Check if OpenClaw is running
if ! pgrep -f "openclaw" > /dev/null; then
    echo "❌ OpenClaw is not running. Start it with: openclaw gateway start"
    exit 1
fi

# Get phone number
PHONE_NUMBER="${1:-$DEFAULT_TEST_NUMBER}"
MESSAGE="${2:-$DEFAULT_MESSAGE}"

echo "🔧 Testing wellness call system..."
echo "📞 Calling: $PHONE_NUMBER"
echo "💬 Message: $MESSAGE"
echo

# Make the test call
openclaw tool voice_call '{
  "action": "initiate_call",
  "to": "'$PHONE_NUMBER'",
  "message": "'$MESSAGE'",
  "mode": "conversation"
}'

echo "✅ Test call initiated!"
echo "📋 Check the OpenClaw logs for call status and any errors."