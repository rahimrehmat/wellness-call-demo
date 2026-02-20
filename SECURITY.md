# Security & Privacy Guidelines

## 🔒 Before You Commit or Share

**NEVER commit these to public repositories:**

- ❌ Real phone numbers
- ❌ API keys or tokens  
- ❌ Account SIDs or secrets
- ❌ Patient names or personal information
- ❌ Actual conversation transcripts (without consent)
- ❌ Real addresses or locations

## ✅ Safe Examples to Share

- ✅ Masked API keys (`sk-xxxxxxxx`, `ACxxxxxxxx`)
- ✅ Placeholder phone numbers (`+1555EXAMPLE`)
- ✅ Generic names (`Patient`, `Margaret`, `Anonymous`)
- ✅ Anonymized transcripts with consent
- ✅ System architecture and code logic

## 📝 Privacy Best Practices

### 1. Environment Variables
```bash
# ✅ Good - use environment variables
TWILIO_AUTH_TOKEN="${TWILIO_AUTH_TOKEN}"

# ❌ Bad - hardcoded secrets
TWILIO_AUTH_TOKEN="abc123secretkey"
```

### 2. Phone Numbers
```bash
# ✅ Good - placeholder in public code
PATIENT_PHONE="+1555PATIENT"  # Replace with actual

# ❌ Bad - real number in code  
PATIENT_PHONE="+15551234567"
```

### 3. Patient Information
```markdown
<!-- ✅ Good - anonymized example -->
**Patient:** Anonymous (example)
**Age:** 80s
**Condition:** Generic kidney condition

<!-- ❌ Bad - real patient data -->
**Patient:** Margaret Smith
**Address:** 123 Main St, Vancouver
**DOB:** 1943-05-15
```

### 4. Conversation Transcripts
- ✅ **WITH consent:** Anonymized transcripts for examples
- ❌ **WITHOUT consent:** Never share real conversations
- ✅ **Synthetic examples:** AI-generated sample conversations
- ✅ **Medical privacy:** Remove specific conditions, medications, dates

## 🔍 Pre-Commit Checklist

Before committing code:

```bash
# Check for phone numbers
grep -r "\+1[0-9]\{10\}" .

# Check for API keys
grep -r "sk-[a-zA-Z0-9]" .
grep -r "AC[a-zA-Z0-9]\{32\}" .

# Check for emails
grep -r "@.*\.com" .

# Check for names (customize for your case)
grep -r "YourPatientName\|YourRealName" .
```

## ⚖️ Legal Considerations

### HIPAA Compliance (US)
- Patient health information requires consent
- Call recordings may need special handling
- Consider Business Associate Agreements with vendors

### Privacy Laws (General)  
- **Consent:** Always get permission before recording/storing
- **Purpose:** Only collect data needed for wellness checks
- **Retention:** Delete old data per your privacy policy
- **Access:** Let patients review their data

### Service Provider Terms
- **Twilio:** Review data handling policies
- **OpenAI:** Understand training data usage  
- **Anthropic:** Check data retention policies
- **ElevenLabs:** Review voice synthesis terms

## 🚨 If You Accidentally Expose Secrets

### 1. Immediate Actions
```bash
# Rotate API keys immediately
# Change passwords  
# Revoke tokens
# Update environment variables
```

### 2. Git History Cleanup  
```bash
# Remove from git history (if recent)
git reset --hard HEAD~1

# For older commits, use git filter-branch or BFG
# Consider making repo private temporarily
```

### 3. Monitor for Abuse
- Check API usage dashboards
- Monitor phone bills for unexpected charges
- Review access logs for unusual activity

## 📞 Incident Response

If patient data is accidentally exposed:

1. **Immediate:** Remove from public access
2. **24 hours:** Notify affected patients  
3. **72 hours:** Report to relevant authorities (if required)
4. **Ongoing:** Monitor for misuse, improve processes

## 🛡️ Recommended Tools

- **git-secrets:** Prevent secrets in commits
- **pre-commit hooks:** Automated checks
- **Environment scanners:** Check for exposed credentials
- **Privacy impact assessment:** Before deployment

---

**Remember:** Patient privacy and security are more important than convenience. When in doubt, keep it private.