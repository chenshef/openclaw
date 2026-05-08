#!/usr/bin/env python3
"""
YouTube Chen - Advanced YouTube Video Analyzer
Converts YouTube videos into comprehensive 50-page technical documents
"""

import json
import subprocess
import sys
from pathlib import Path
from datetime import datetime

class YouTubeChen:
    def __init__(self, video_url, mode="watch_later"):
        """
        Initialize YouTube Chen
        
        Args:
            video_url: YouTube video URL
            mode: "watch_later" or "full_analysis"
        """
        self.video_url = video_url
        self.mode = mode
        self.output_dir = Path("youtube_chen_output")
        self.output_dir.mkdir(exist_ok=True)
        
    def extract_metadata(self):
        """Extract video metadata using yt-dlp"""
        print(f"📥 Extracting metadata from: {self.video_url}")
        
        cmd = [
            "yt-dlp",
            "--dump-json",
            "--skip-download",
            self.video_url
        ]
        
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode != 0:
            print(f"❌ Error: {result.stderr}")
            return None
            
        metadata = json.loads(result.stdout)
        return metadata
    
    def extract_transcript(self):
        """Extract subtitles/transcript"""
        print("📝 Extracting transcript...")
        
        cmd = [
            "yt-dlp",
            "--write-auto-sub",
            "--sub-lang", "en,he,iw",
            "--skip-download",
            "--output", str(self.output_dir / "%(id)s"),
            self.video_url
        ]
        
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.returncode == 0
    
    def save_watch_later(self, metadata):
        """Save to watch later database"""
        db_file = self.output_dir / "watch_later.jsonl"
        
        entry = {
            "video_id": metadata.get("id"),
            "title": metadata.get("title"),
            "url": self.video_url,
            "channel": metadata.get("uploader"),
            "duration": metadata.get("duration"),
            "added_date": datetime.now().isoformat(),
            "description": metadata.get("description", "")[:500],
            "thumbnail": metadata.get("thumbnail")
        }
        
        with open(db_file, "a", encoding="utf-8") as f:
            f.write(json.dumps(entry, ensure_ascii=False) + "\n")
        
        print(f"💾 Saved to watch later: {entry['title']}")
        return entry
    
    def analyze_tools_and_commands(self, metadata, transcript):
        """Analyze technical content for tools, commands, technologies"""
        print("🔍 Analyzing technical content...")
        
        # Extract description links
        description = metadata.get("description", "")
        links = self._extract_links(description)
        
        # TODO: Use LLM (Claude/Gemini) to analyze transcript
        # - Identify tools mentioned
        # - Extract commands
        # - Detect technologies
        # - Create structured data
        
        return {
            "links": links,
            "tools": [],  # TODO: Fill with LLM analysis
            "commands": [],  # TODO: Fill with LLM analysis
            "technologies": []  # TODO: Fill with LLM analysis
        }
    
    def _extract_links(self, text):
        """Extract URLs from text"""
        import re
        url_pattern = r'https?://[^\s<>"{}|\\^`\[\]]+'
        return re.findall(url_pattern, text)
    
    def generate_full_document(self, metadata, analysis):
        """Generate comprehensive 50-page technical document"""
        print("📄 Generating full technical document...")
        
        # TODO: Use Claude/Gemini to generate:
        # - Executive summary
        # - Technical breakdown by timestamp
        # - Tools table with descriptions
        # - Commands table with syntax
        # - Architecture diagrams (Mermaid)
        # - Infographics
        # - Link reference table
        # - Index
        
        doc_path = self.output_dir / f"{metadata['id']}_full_doc.md"
        
        with open(doc_path, "w", encoding="utf-8") as f:
            f.write(f"# {metadata['title']}\n\n")
            f.write(f"**Channel:** {metadata.get('uploader')}\n")
            f.write(f"**Duration:** {metadata.get('duration')} seconds\n")
            f.write(f"**URL:** {self.video_url}\n\n")
            f.write("## Links from Description\n\n")
            for link in analysis['links']:
                f.write(f"- {link}\n")
            
            # TODO: Complete with LLM-generated content
        
        print(f"✅ Document saved: {doc_path}")
        return doc_path
    
    def run(self):
        """Main execution flow"""
        print(f"\n🎬 YouTube Chen - Mode: {self.mode.upper()}\n")
        
        # Step 1: Extract metadata
        metadata = self.extract_metadata()
        if not metadata:
            print("❌ Failed to extract metadata")
            return
        
        print(f"✅ Video: {metadata['title']}")
        print(f"✅ Channel: {metadata.get('uploader')}")
        print(f"✅ Duration: {metadata.get('duration')} seconds\n")
        
        if self.mode == "watch_later":
            # Quick save to watchlist
            self.save_watch_later(metadata)
            print("\n✅ Added to watch later list!")
            
        elif self.mode == "full_analysis":
            # Full processing
            self.extract_transcript()
            analysis = self.analyze_tools_and_commands(metadata, None)
            doc_path = self.generate_full_document(metadata, analysis)
            print(f"\n✅ Full analysis complete! Document: {doc_path}")


def main():
    if len(sys.argv) < 2:
        print("Usage: python youtube-chen.py <video_url> [mode]")
        print("Modes: watch_later (default), full_analysis")
        sys.exit(1)
    
    video_url = sys.argv[1]
    mode = sys.argv[2] if len(sys.argv) > 2 else "watch_later"
    
    chen = YouTubeChen(video_url, mode)
    chen.run()


if __name__ == "__main__":
    main()
