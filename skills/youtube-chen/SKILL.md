---
name: youtube-chen
description: >-
  YouTube video processor and watchlist manager for Chen. Use when a YouTube URL is shared
  (youtube.com, youtu.be) or user requests save video, watch later, full analysis, מסמך מעמיק,
  שמור לצפייה מאוחרת. Saves to watch-later list or generates a comprehensive technical analysis
  document. Always ask the user which mode before proceeding.
---

# YouTube Chen

## Workflow

### Step 1: Receive URL
When a YouTube URL is detected, ask:
> "לשמור לצפייה מאוחרת או להכין מסמך ניתוח מעמיק? 💾📄"

### Step 2a: Watch Later Mode (💾)
```bash
cd /home/openclaw/.openclaw/workspace
PATH="$HOME/.local/bin:$PATH" python3 youtube_chen_tools.py <URL>
```
- Saves to `youtube_chen_watchlist.jsonl`
- Confirm with title + channel name

### Step 2b: Full Analysis Mode (📄)

**Before running — show cost/time estimate:**

1. Fetch video metadata first:
```bash
PATH="$HOME/.local/bin:$PATH" yt-dlp --dump-json --skip-download <URL> 2>/dev/null | python3 -c "
import json,sys
d=json.load(sys.stdin)
dur=d.get('duration',0)
mins=dur//60
# estimate: ~150 words/min transcript, ~1.3 tokens/word
tokens_in = int(dur * 150/60 * 1.3)
tokens_out = 8000  # ~50 page doc
cost = (tokens_in * 3 + tokens_out * 15) / 1_000_000
time_est = max(2, mins // 10)
print(f'title={d[\"title\"]}')
print(f'duration={mins}min')
print(f'tokens_in={tokens_in:,}')
print(f'cost_usd={cost:.3f}')
print(f'time_min={time_est}')
"
```

2. Show estimate to user:
> "⏱️ זמן משוער: ~X דקות | 💰 עלות: ~$X.XX (Claude API) | רוצה להמשיך?"

3. Only after confirmation, run:
```bash
cd /home/openclaw/.openclaw/workspace
PATH="$HOME/.local/bin:$PATH" python3 youtube-chen.py <URL> full_analysis
```

4. After generating the document, upload to Google Drive with `import_to_google_doc` and send the user the Drive link via Telegram in this exact format:
```
📄 המסמך מוכן!

[<title> - ניתוח מעמיק](<google_doc_link>)
```

## Cost Reference (Claude Sonnet 4)
- Input: $3 / 1M tokens
- Output: $15 / 1M tokens
- Typical 1hr video: ~$0.05–0.15

## Files
- `youtube_chen_tools.py` — watch later utilities
- `youtube-chen.py` — full analysis generator  
- `youtube_chen_watchlist.jsonl` — watch later DB
- `send_daily_watchlist.py` — daily digest (cron at 20:30)

## Important
- Always use `PATH="$HOME/.local/bin:$PATH"` prefix — yt-dlp is at `~/.local/bin/yt-dlp`
- Scripts live in `/home/openclaw/.openclaw/workspace/`
- Full analysis requires transcript availability (auto-subs fallback)

## References
- See `references/pricing.md` for up-to-date token pricing notes
