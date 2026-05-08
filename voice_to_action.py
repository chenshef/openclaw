#!/usr/bin/env python3
"""
Voice-to-Action Skill
Transcribes voice messages and executes tasks, creates events, etc.
"""

import sys
import subprocess
import json
import os
from pathlib import Path

def transcribe_audio(audio_path):
    """Transcribe audio using OpenAI Whisper"""
    try:
        # Use whisper CLI
        result = subprocess.run(
            ['whisper', audio_path, '--model', 'base', '--language', 'he', '--output_format', 'json'],
            capture_output=True,
            text=True,
            timeout=60
        )
        
        if result.returncode != 0:
            print(f"Error: {result.stderr}", file=sys.stderr)
            return None
        
        # Whisper outputs JSON file
        json_file = Path(audio_path).with_suffix('.json')
        if json_file.exists():
            with open(json_file) as f:
                data = json.load(f)
                return data.get('text', '')
        
        return None
    except Exception as e:
        print(f"Transcription error: {e}", file=sys.stderr)
        return None

def parse_intent(text):
    """Parse transcribed text to identify intent"""
    text_lower = text.lower()
    
    # Task keywords
    if any(word in text_lower for word in ['משימה', 'task', 'תזכורת', 'reminder', 'לעשות', 'todo']):
        return {'type': 'task', 'text': text}
    
    # Calendar keywords
    if any(word in text_lower for word in ['פגישה', 'meeting', 'אירוע', 'event', 'לוח שנה', 'calendar']):
        return {'type': 'calendar', 'text': text}
    
    # Email keywords
    if any(word in text_lower for word in ['מייל', 'email', 'שלח', 'send']):
        return {'type': 'email', 'text': text}
    
    # Shopping list
    if any(word in text_lower for word in ['קניות', 'shopping', 'לקנות', 'buy']):
        return {'type': 'shopping', 'text': text}
    
    # General note
    return {'type': 'note', 'text': text}

def main():
    if len(sys.argv) < 2:
        print("Usage: python voice_to_action.py <audio_file>")
        sys.exit(1)
    
    audio_file = sys.argv[1]
    
    if not os.path.exists(audio_file):
        print(f"Error: File not found: {audio_file}")
        sys.exit(1)
    
    print(f"🎤 Transcribing: {audio_file}")
    
    # Transcribe
    text = transcribe_audio(audio_file)
    
    if not text:
        print("❌ Failed to transcribe audio")
        sys.exit(1)
    
    print(f"📝 Transcription: {text}")
    
    # Parse intent
    intent = parse_intent(text)
    
    print(f"🎯 Intent: {intent['type']}")
    print(f"✅ Ready for action!")
    
    # Output JSON for OpenClaw to process
    output = {
        'transcription': text,
        'intent': intent['type'],
        'content': text
    }
    
    print(json.dumps(output, ensure_ascii=False))

if __name__ == '__main__':
    main()
