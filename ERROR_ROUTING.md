# ERROR_ROUTING.md - System Error Message Routing

## ⚠️ Critical Rule: WhatsApp Error Prohibition

**NEVER send system error messages to WhatsApp!**

---

## ❌ Forbidden on WhatsApp:

- API errors (rate limits, timeouts, etc.)
- Authentication errors (401, 403, etc.)
- Model errors (context length, refusal, etc.)
- Network errors (connection failed, timeout, etc.)
- Database errors
- File system errors
- Stack traces
- Technical diagnostics
- System warnings
- Any internal error messages

---

## ✅ Where System Errors ARE Allowed:

### **1. Console/Logs:**
```bash
ERROR: API rate limit reached
WARNING: Low disk space
```

### **2. Email:**
```
Subject: [OpenClaw] System Alert
Body: API authentication error occurred...
```

### **3. Telegram:**
```
⚠️ System Alert:
API rate limit reached — the model couldn't generate a response.
Please try again in a moment.
```

---

## 🎯 WhatsApp Response Policy:

**If a system error occurs during a WhatsApp conversation:**

1. ❌ **DO NOT** send the error to WhatsApp
2. ✅ **DO** log it to console
3. ✅ **DO** notify via Telegram (if configured)
4. ✅ **DO** send a user-friendly message to WhatsApp (optional):
   - "אני נתקל בבעיה, תנסה שוב בעוד רגע" (I encountered an issue, try again in a moment)
   - "לא הצלחתי לעבד את הבקשה, תנסה שוב" (Couldn't process the request, try again)

**Never expose technical details on WhatsApp!**

---

## 📋 Summary:

| Error Type | Console | Email | Telegram | WhatsApp |
|------------|---------|-------|----------|----------|
| API Errors | ✅ | ✅ | ✅ | ❌ |
| Auth Errors | ✅ | ✅ | ✅ | ❌ |
| Rate Limits | ✅ | ✅ | ✅ | ❌ |
| System Warnings | ✅ | ✅ | ✅ | ❌ |
| User-friendly messages | ❌ | ❌ | ✅ | ✅ |

---

**Last updated:** 2026-04-21 20:58
**Status:** ACTIVE - Enforced on all WhatsApp interactions
