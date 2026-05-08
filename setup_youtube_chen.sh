#!/bin/bash
# Setup YouTube Chen daily notification

# Create the cron job via openclaw CLI
openclaw cron add \
  --name "YouTube Chen - Daily Watchlist" \
  --schedule "30 20 * * *" \
  --tz "Asia/Jerusalem" \
  --isolated \
  --delivery announce \
  --channel telegram \
  --to 556056149 \
  "הגיע הזמן לשלוח את טבלת הצפייה היומית של YouTube Chen! הרץ את הסקריפט והצג את הטבלה למשתמש."

echo "✅ YouTube Chen cron job created!"
echo "📅 Will run daily at 20:30 Israel time"
