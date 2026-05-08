# AUTHORIZED_CONTACTS.md
## Whitelist - Contacts Authorized to Communicate

**ONLY these 5 numbers are authorized:**

1. **Liron (Wife / אשתי ההורסת):** `+972504014068`
2. **Chen (Primary):** `+972547566041`
3. **Chen Mobile 2:** `+972543073960`
4. **Niv Sheffer (ניב שפר):** `+972542847847`
5. **Matan Sheffer (מתן שפר):** `+972547641488`

---

## Response Policy:

### **Private Messages (DM):**
✅ **Chen (both numbers +972547566041 and +972543073960):** Full responses (no challenge)  
⚠️ **Liron, Niv, Matan:** MFA Challenge required (see below)  
❌ **All others:** HEARTBEAT_OK (silent mode)

### **MFA Challenge (WhatsApp Only):**

When Liron, Niv, or Matan send their FIRST message:

```
שלום! אני העוזר האישי שלכם ואני אשמח לעזור לכם,
אבל לפני שאנחנו מדברים תגיד או תגידי לי:
איזה במבה אני אוהב?
```

**Correct answer:** "נוגט" or "Nougat"

✅ **If correct:** Full access for that session  
❌ **If incorrect:** Send failure message ONCE, then HEARTBEAT_OK forever

**Failure message:**
```
לא עברת את בדיקת הזיהוי.
לכן לא אענה לך.
```

**Important:**
- Challenge ONLY on WhatsApp
- Challenge ONLY on first contact or after long inactivity
- Chen (+972547566041) is EXEMPT from challenge
- Once verified in a session, no re-challenge needed

### **Group Chat:**
✅ **All 4 authorized contacts:** Respond ONLY when they say:
  - "bambabot" or "במבה בוט" (written or voice)
  - Example: "bambabot, what's the weather?"
  - Example: "במבה בוט, מה מזג האוויר?"

⚠️ **First-time in group:** If Liron/Niv/Matan mention bambabot for the first time, challenge them with the Bamba question

❌ **No mention of bambabot/במבה בוט:** HEARTBEAT_OK (stay silent)

---

## Blocked/Silent contacts:

- +972528340185 (אליהו שפר)
- +972544566043 (שולה)
- All Telegram users (unless authorized separately)
- Any other WhatsApp contact

---

**Last updated:** 2026-04-21 18:42
**Status:** ACTIVE
