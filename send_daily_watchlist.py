#!/usr/bin/env python3
"""
Send daily YouTube Chen watchlist via Telegram
Run by cron at 20:30
"""

import sys
import subprocess
sys.path.insert(0, '/home/openclaw/.openclaw/workspace')

from youtube_chen_tools import get_todays_watchlist, format_watchlist_table

TELEGRAM_TARGET = "556056149"
OPENCLAW_BIN = "/usr/local/bin/openclaw"

def main():
    videos = get_todays_watchlist()
    table = format_watchlist_table(videos)
    if not table or not table.strip():
        # Nothing to send today
        sys.exit(0)
    result = subprocess.run(
        [OPENCLAW_BIN, "message", "send",
         "--channel", "telegram",
         "--target", TELEGRAM_TARGET,
         "--message", table],
        capture_output=True,
        text=True
    )
    if result.returncode != 0:
        print(f"Error sending message: {result.stderr}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
