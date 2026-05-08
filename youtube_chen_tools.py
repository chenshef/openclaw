#!/usr/bin/env python3
"""
YouTube Chen Tools - Integration functions for OpenClaw
"""

import json
import subprocess
import re
from pathlib import Path
from datetime import datetime

WATCH_LATER_DB = Path.home() / ".openclaw/workspace/youtube_chen_watchlist.jsonl"
WATCH_LATER_DB.parent.mkdir(parents=True, exist_ok=True)

def extract_video_id(url):
    """Extract YouTube video ID from various URL formats"""
    patterns = [
        r'(?:youtube\.com/watch\?v=|youtu\.be/|youtube\.com/embed/)([a-zA-Z0-9_-]{11})',
        r'youtube\.com/shorts/([a-zA-Z0-9_-]{11})'
    ]
    for pattern in patterns:
        match = re.search(pattern, url)
        if match:
            return match.group(1)
    return None

def get_video_metadata(video_url):
    """Get video metadata using yt-dlp"""
    cmd = [
        "yt-dlp",
        "--dump-json",
        "--skip-download",
        video_url
    ]
    
    result = subprocess.run(cmd, capture_output=True, text=True)
    
    if result.returncode != 0:
        return None
    
    return json.loads(result.stdout)

def save_to_watchlist(video_url, metadata):
    """Save video to watch later list"""
    video_id = extract_video_id(video_url)
    
    entry = {
        "video_id": video_id,
        "title": metadata.get("title"),
        "url": video_url,
        "channel": metadata.get("uploader"),
        "duration": metadata.get("duration"),
        "duration_string": metadata.get("duration_string"),
        "added_date": datetime.now().isoformat(),
        "added_time": datetime.now().strftime("%H:%M"),
        "description": metadata.get("description", "")[:300],
        "thumbnail": metadata.get("thumbnail"),
        "view_count": metadata.get("view_count"),
        "tags": metadata.get("tags", [])[:10]
    }
    
    # Append to JSONL database
    with open(WATCH_LATER_DB, "a", encoding="utf-8") as f:
        f.write(json.dumps(entry, ensure_ascii=False) + "\n")
    
    return entry

def get_todays_watchlist():
    """Get all videos added today"""
    if not WATCH_LATER_DB.exists():
        return []
    
    today = datetime.now().date().isoformat()
    todays_videos = []
    
    with open(WATCH_LATER_DB, "r", encoding="utf-8") as f:
        for line in f:
            entry = json.loads(line)
            if entry["added_date"].startswith(today):
                todays_videos.append(entry)
    
    return todays_videos

def format_watchlist_table(videos):
    """Format watchlist as Markdown table"""
    if not videos:
        return "אין סרטונים לצפייה היום 📺"
    
    table = "# 📺 רשימת צפייה להיום\n\n"
    table += f"**{len(videos)} סרטונים** נשמרו היום\n\n"
    table += "| # | 🎬 סרטון | ⏱️ משך | 📺 ערוץ | 🔗 לינק |\n"
    table += "|---|----------|---------|---------|--------|\n"
    
    for i, video in enumerate(videos, 1):
        title = video["title"][:50] + "..." if len(video["title"]) > 50 else video["title"]
        duration = video.get("duration_string", "N/A")
        channel = video["channel"][:20] + "..." if len(video["channel"]) > 20 else video["channel"]
        url = video["url"]
        
        table += f"| {i} | {title} | {duration} | {channel} | [צפה]({url}) |\n"
    
    return table

# Test function
if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        url = sys.argv[1]
        print("Fetching metadata...")
        metadata = get_video_metadata(url)
        if metadata:
            print(f"✅ {metadata['title']}")
            save_to_watchlist(url, metadata)
            print("💾 Saved to watchlist")
