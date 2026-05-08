# MEMORY.md - Long-Term Memory

## Obsidian Integration 🗒️

**מחובר לחלוטין** — תמיד השתמש בזה לשמירת נוטות!

- **Vault פעיל:** AI-Second-Brain
- **REST API:** `http://192.168.14.90:27125`
- **API Key:** `51048b3be5137e8ecd53dabcd78974e09cc0d6a7405318e5780eab249f021757`
- **תיקיית PROJECTS:** `/vault/PROJECTS/` (מחליפה את PROJECTS-Obsidian)
- **WinRM:** `http://192.168.14.90:5985` | user: `chenshef1`

### כיצד לכתוב נוטה:
```bash
curl -s -X PUT \
  -H "Authorization: Bearer 51048b3be5137e8ecd53dabcd78974e09cc0d6a7405318e5780eab249f021757" \
  -H "Content-Type: text/markdown" \
  -d "תוכן הנוטה" \
  "http://192.168.14.90:27125/vault/שם-קובץ.md"
```

### מיפוי כוונות מטלגרם:
- `שמור רעיון: ...` → `/vault/רעיונות/YYYY-MM-DD-רעיון.md`
- `פרויקט: ...` → `/vault/PROJECTS/שם.md`
- `נוטה: כותרת | תוכן` → `/vault/Notes/כותרת.md`
- כל הודעה אחרת שמבקשת שמירה → שמור ב-`/vault/Inbox/YYYY-MM-DD-HH-MM.md`

---

## הגדרות כלליות
- **שם:** Chen Sheffer
- **Timezone:** Asia/Jerusalem (GMT+3)
- **Google Personal:** chenshef@gmail.com
- **Google Work:** chen@chensheffer.com
