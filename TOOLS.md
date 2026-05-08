# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Telegram

- Bot: @Bambaocbot
- Link: https://web.telegram.org/k/#@Bambaocbot
- User ID: 556056149
- Username: @chenshefking

## WhatsApp

- Status: Connected (linked device)
- Mode: Pairing (secure DMs only)
- Linked: Sat 2026-04-18

## YouTube Chen 🎬

**Automatic YouTube video processor and watchlist manager**

### When I send a YouTube link:
1. You extract video metadata (title, channel, duration)
2. You ask: **"לשמור לצפייה מאוחר או להכין מסמך מעמיק?"**
3. Options:
   - 💾 **"שמור" / "watch later"** → Save to watchlist only
   - 📄 **"מסמך מעמיק" / "full analysis"** → Generate comprehensive technical document

### Watch Later Mode (💾):
- Run: `python3 youtube_chen_tools.py <URL>`
- Saves to: `~/.openclaw/workspace/youtube_chen_watchlist.jsonl`
- Daily summary sent at **20:30** (Israel time) via cron

### Full Analysis Mode (📄):
- Run: `python3 youtube-chen.py <URL> full_analysis`
- Generates 50-page technical document with:
  - 📊 Tools & technologies table
  - 💻 Commands & syntax table
  - 🔗 Links from description
  - 📈 Diagrams & infographics
  - 🎯 Technical breakdown by timestamp

### Files:
- `youtube_chen_tools.py` - Core utilities
- `youtube-chen.py` - Full document generator
- `send_daily_watchlist.py` - Daily notification script
- `youtube_chen_watchlist.jsonl` - Watch later database

### Cron:
```cron
30 20 * * * cd /home/openclaw/.openclaw/workspace && python3 send_daily_watchlist.py >> /home/openclaw/backups/watchlist.log 2>&1
```

---

## Voice-to-Action 🎤

**Automatic voice message transcription and task execution**

### Setup:
- ffmpeg: ✅ Installed
- OpenAI Whisper: ✅ **Installed!** (base model)
- Virtual env: `whisper_env/`
- Scripts: `transcribe_voice.py`, `run_whisper.sh`

### How it works:
1. Chen sends a voice message via Telegram/WhatsApp
2. OpenClaw downloads the audio file (.ogg, .mp3, .wav)
3. Whisper transcribes it (Hebrew/English auto-detect)
4. I process the text and respond (with TTS if requested)

### Usage:
```bash
# Manual transcription
~/.openclaw/workspace/run_whisper.sh <audio_file>

# Example
~/.openclaw/workspace/run_whisper.sh /path/to/voice.ogg
```

### Examples:
- "תזכור לי לקנות חלב מחר" → I'll create a reminder
- "מה מי זה גבירים?" → I'll answer your question
- "כמה זה עולה?" → I'll calculate/answer

### Files:
- `transcribe_voice.py` - Main transcription script
- `run_whisper.sh` - Wrapper script for easy execution
- `whisper_env/` - Python virtual environment with Whisper
- Uses Whisper base model (74MB, offline capable)
- Hebrew + English support with auto-detection

### TTS (Text-to-Speech):
- ✅ Available via OpenClaw's built-in TTS tool
- Supports English output
- Usage: I can read responses back to you in English

---

## Obsidian Integration 🗒️

**חיבור ל-Obsidian על המחשב של Chen (192.168.14.90)**

### Vaults:
- `C:\Users\chenshef1\Documents\AI-Second-Brain` ← פלאגין Local REST API מותקן כאן
- `C:\Users\chenshef1\Documents\PROJECTS-Obsidian`

### Local REST API:
- **URL:** `http://192.168.14.90:27125` (port proxy → 127.0.0.1:27123)
- **API Key:** `51048b3be5137e8ecd53dabcd78974e09cc0d6a7405318e5780eab249f021757`
- **גרסה:** 3.6.2

### WinRM (גישה ל-Windows):
- **Host:** `192.168.14.90:5985`
- **User:** `chenshef1`
- **Transport:** basic
- **שימוש:** `pywinrm` (מותקן)

### דוגמת שימוש:
```python
import winrm
s = winrm.Session('http://192.168.14.90:5985/wsman', auth=('chenshef1', 'Aa123456'), transport='basic')
r = s.run_ps('...')
```

```bash
# קריאת נוטה מ-Obsidian
curl -s -H "Authorization: Bearer 51048b3be5137e8ecd53dabcd78974e09cc0d6a7405318e5780eab249f021757" http://192.168.14.90:27125/vault/
```

### Vaults וגישה:
| Vault | נתיב | REST API Port | סטטוס |
|---|---|---|---|
| AI-Second-Brain | `C:\Users\chenshef1\Documents\AI-Second-Brain` | 27125 | ✅ פעיל |
| PROJECTS-Obsidian | `C:\Users\chenshef1\Documents\PROJECTS-Obsidian` | 27127 | ✅ מוגדר (צריך enable ב-Obsidian) |

### הערות:
- פורט 27125 = port proxy ל-AI-Second-Brain (Firewall: "Obsidian Proxy")
- פורט 27127 = port proxy ל-PROJECTS-Obsidian (Firewall: "Obsidian PROJECTS Proxy")
- הפלאגין מאזין על 127.0.0.1 בלבד — ה-proxy מגשר
- WinRM מאפשר לי להריץ PowerShell על המחשב ישירות

---

Add whatever helps you do your job. This is your cheat sheet.
