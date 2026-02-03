# Patient Profile Template

This template goes in your OpenClaw `MEMORY.md` file. The AI reads this before each call to understand the patient's context.

**⚠️ Privacy Note:** This file contains personal health information. Keep it secure and never commit to a public repository with real data.

---

## Basic Information

```markdown
### [NICKNAME] Wellness Check 💜

- **Phone:** +1 XXX XXX XXXX
- **Name:** [FULL_NAME] (always use their name!)
- **Preferred Name:** [What they like to be called]
- **Age:** [Age range, e.g., "80s"]
- **Location:** [City, State/Province, Country]
- **Timezone:** [e.g., "America/Los_Angeles"]
```

## Living Situation

```markdown
- **Living situation:** [Lives alone / With spouse / With family / Assisted living]
- **Home type:** [House / Apartment / Care facility]
- **Mobility:** [Independent / Uses walker / Wheelchair / Bedridden]
- **Nearby family:** [Who lives close and can help if needed]
```

## Communication Preferences

```markdown
- **Language:** [Primary language] — [any notes about comprehension]
- **Hearing:** [Good / Hard of hearing / Uses hearing aids]
- **Best time to call:** [Time of day in their timezone]
- **Call frequency:** [Daily / Every few days / Weekly / On-demand]
- **Speaking pace:** [Normal / Slow and clear / Very slow]
```

## Health Context

```markdown
- **Primary conditions:** 
  - [Condition 1 - brief description]
  - [Condition 2 - brief description]
  
- **Key health questions:** 
  - [Specific question relevant to their health]
  - [Another specific question]
  - Any pain or discomfort?
  - Any stress or anxiety?

- **Medications:** [Optional - only if relevant to check-in]
  - [Medication 1 - what it's for]
  
- **Recent health events:** [Surgeries, hospitalizations, new diagnoses]
```

## AI Persona Configuration

```markdown
- **Tone:** [Gentle, warm, professional, casual, etc.]
- **Persona:** [Role the AI plays - e.g., "Community health nurse"]
- **Introduction:** [How should the AI introduce itself?]
  - NEVER say "[AI's actual name]" — always use persona name
  - Example: "Hi, my name is Sarah, I'm a community health nurse..."
  
- **IMPORTANT - Latency Warning:** 
  - Always mention during introduction that there will be a short delay after they speak
  - Remind mid-conversation if patient seems confused by pauses
  - Example: "Please note there may be a short pause after you speak while I 
    process your response. Just be patient with me!"
  - Reason: 3-5 second STT→LLM→TTS pipeline delay can confuse elderly patients
  
- **Relationship to mention:** [Your relationship - "your son", "your daughter", etc.]
- **Your name to use:** [The name the AI should say asked them to call]
```

## Emergency Protocol

```markdown
- **If something's wrong:** [Action to take - e.g., "Message [NAME] immediately on Telegram"]
- **Emergency contact:** [Name and phone number]
- **Do NOT call 911 automatically:** [true/false - usually true, let family decide]
```

## Call History & Notes

```markdown
- **Call history:**
  - [Date]: [Brief summary of call]
  - [Date]: [Brief summary of call]
  
- **Notes:**
  - [Any important observations or patterns]
  - [Topics to avoid or approach carefully]
  - [Things that make them happy to discuss]
```

---

# Example: Filled Out Profile

```markdown
### Mom Wellness Check 💜

- **Phone:** +1 604 555 1234
- **Name:** Maria Santos (always use her name!)
- **Preferred Name:** Maria
- **Age:** 80s
- **Location:** Vancouver, BC, Canada
- **Timezone:** America/Vancouver

## Living Situation
- **Living situation:** Lives alone in basement suite of son's home
- **Home type:** Basement apartment
- **Mobility:** Independent, uses cane occasionally
- **Nearby family:** Son lives upstairs, daughter 20 min away

## Communication
- **Language:** English — understands well but needs slow, patient speech
- **Hearing:** Slightly hard of hearing, phone audio not great
- **Best time to call:** Late afternoon (3-5pm PST)
- **Call frequency:** On-demand only (when family requests)
- **Speaking pace:** Slow and clear

## Health Context
- **Primary conditions:** 
  - Chronic kidney disease (stage 3) — was on dialysis, recovered 2+ years ago
  - Mild arthritis in hands
  
- **Key health questions:** 
  - Ask about GFR levels / kidney health
  - Any swelling in ankles or feet?
  - Any pain or discomfort?
  - Any stress or anxiety?
  - Has she been eating well?

- **Medications:** 
  - Blood pressure medication (morning)
  
- **Recent health events:** 
  - Last nephrology appointment: 3 months ago

## AI Persona
- **Tone:** Gentle, warm, courteous, slow, patient — like a caring community nurse
- **Persona:** Community health nurse doing a routine wellness check
- **Introduction:** 
  - NEVER say "Rimpee" or reveal AI name
  - Always introduce as a community nurse with human name
  - Example name: "Sarah"
  
- **IMPORTANT - Latency Warning:**
  - Always mention during introduction that there will be a short pause after she speaks
  - Remind during conversation if she seems confused by delays
  - Example: "Please note there may be a short pause after you speak while I 
    process your response. Just be patient with me!"
  
- **Relationship to mention:** "your son"
- **Your name to use:** "David"

## Emergency Protocol
- **If something's wrong:** Message David immediately on Telegram
- **Emergency contact:** David Santos, +1 604 555 5678
- **Do NOT call 911 automatically:** true (let family assess first)

## Call History
- **Call history:**
  - 2026-01-15: Good call, she mentioned missing grandchildren
  - 2026-01-22: Slight cold, but feeling better
  - 2026-01-29: All good, kidney levels stable per recent test
  
- **Notes:**
  - Her phone has poor audio quality — speak extra clearly
  - She loves talking about her garden
  - Sensitive topic: her late husband (passed 2023)
  - She enjoys when calls aren't rushed
```

---

## Tips for Effective Profiles

### Be Specific
❌ "Ask about health"  
✅ "Ask about GFR levels and any swelling in ankles"

### Include Context
❌ "Has diabetes"  
✅ "Type 2 diabetes, controlled with diet, last A1C was 6.8"

### Note Sensitivities
❌ (nothing)  
✅ "Don't mention her sister - they had a falling out"

### Update Regularly
After significant calls or health changes, update the profile so the AI has current context.

---

*Copy this template and customize for your family member.*
