# Configuration Profiles

## 🎯 Quick Reference

**Want to switch?** Just say:
```
במבה בוט, תעבור לקונפיגורציה 1
במבה בוט, תעבור לקונפיגורציה 2
במבה בוט, תעבור לקונפיגורציה 3
```

---

## 📋 Available Profiles

### **Profile 1️⃣ - WhatsApp: Chen Only**

**File:** `1-whatsapp-chen-only.json`

**Description:** Maximum security - ONLY Chen's 2 numbers can contact.

**Features:**
- ✅ WhatsApp enabled
- ✅ ONLY 2 numbers authorized:
  - +972547566041 (Chen Primary)
  - +972543073960 (Chen Mobile 2)
- ❌ Everyone else: HEARTBEAT_OK (silent)
- ❌ No MFA needed (only Chen)
- ❌ Group chat disabled (for others)
- ✅ Blocks voice, video, text from all others
- ✅ Telegram enabled (parallel)

**Use when:** You want total privacy - only you can contact the bot.

---

### **Profile 2️⃣ - WhatsApp: Full (Family + MFA)**

**File:** `2-whatsapp-full.json`

**Description:** Complete WhatsApp security with MFA and family access.

**Features:**
- ✅ WhatsApp enabled
- ✅ 5 authorized contacts:
  - +972504014068 (Liron - Wife)
  - +972547566041 (Chen Primary)
  - +972543073960 (Chen Mobile 2)
  - +972542847847 (Niv Sheffer)
  - +972547641488 (Matan Sheffer)
- ✅ MFA challenge for Liron, Niv, Matan
- ✅ Secret question: "איזה במבה אני אוהב?" → "נוגט"
- ✅ Group chat support ("שפר בקשי")
- ✅ Telegram enabled (parallel)

**Use when:** You want family to have access with security.

---

### **Profile 3️⃣ - Telegram Only**

**File:** `3-telegram-only.json`

**Description:** Telegram-only setup with no WhatsApp.

**Features:**
- ❌ WhatsApp disabled
- ✅ Telegram only (@Bambaocbot)
- ✅ No restrictions
- ✅ Google Workspace integration
- ✅ Whisper Small (Hebrew + English)

**Use when:** You want to disable WhatsApp completely.

---

## 🔄 Switching Profiles

### **Via Bot Command:**

```
במבה בוט, תעבור לקונפיגורציה 1
במבה בוט, תעבור לקונפיגורציה 2
במבה בוט, תעבור לקונפיגורציה 3
```

Or:

```
bambabot, switch to config 1
bambabot, switch to config 2
bambabot, switch to config 3
```

---

### **Via Command Line:**

```bash
# Switch to Profile 1 (Chen Only)
~/.openclaw/workspace/config-profiles/switch.sh 1

# Switch to Profile 2 (Full Family)
~/.openclaw/workspace/config-profiles/switch.sh 2

# Switch to Profile 3 (Telegram Only)
~/.openclaw/workspace/config-profiles/switch.sh 3
```

---

## 📊 Profile Comparison

| Feature | Profile 1 | Profile 2 | Profile 3 |
|---------|-----------|-----------|-----------|
| **WhatsApp** | ✅ Chen Only | ✅ Family + MFA | ❌ Disabled |
| **Authorized Contacts** | 2 (Chen x2) | 5 (Family) | 0 |
| **MFA Challenge** | ❌ | ✅ | ❌ |
| **Group Chat** | ❌ | ✅ | ❌ |
| **Telegram** | ✅ | ✅ | ✅ |
| **Privacy Level** | 🔒🔒🔒 Max | 🔒🔒 High | 🔒 Medium |

---

## 💾 Backup Before Switching

**Always backup before switching:**

```bash
~/.openclaw/workspace/backup-skill/backup.sh
~/.openclaw/workspace/config-profiles/switch.sh 2
```

---

## 🔙 Restore if Needed

If something breaks:

```bash
~/.openclaw/workspace/backup-skill/restore.sh backups/backup-YYYY-MM-DD-HHMMSS.tar.gz
```

---

## 📍 Current Profile

Check which profile is active:

```bash
cat ~/.openclaw/workspace/.current-profile.json | jq '.profile_id, .profile_name'
```

---

## 🎯 Quick Commands

```bash
# List all profiles
ls -1 ~/.openclaw/workspace/config-profiles/*.json

# Show current profile
cat ~/.openclaw/workspace/.current-profile.json | jq

# Switch to Profile 1
./switch.sh 1

# Backup current config
../backup-skill/backup.sh
```

---

## 📝 Notes

- **Profile 1** is the most secure (only you)
- **Profile 2** is currently active
- **Profile 3** disables WhatsApp entirely
- All profiles include Google Workspace + Whisper
- Switching creates automatic backup
