#!/usr/bin/env python3
"""
Voice Message Transcription using OpenAI Whisper
Supports Hebrew and English
"""

import whisper
import sys
import os

def transcribe_audio(audio_path, model_name="small"):
    """
    Transcribe audio file using Whisper
    
    Args:
        audio_path: Path to audio file (ogg, mp3, wav, etc.)
        model_name: Whisper model size (tiny, base, small, medium, large)
                   small = great for Hebrew (244MB) - DEFAULT
                   base = lighter (74MB)
    
    Returns:
        Transcribed text
    """
    
    if not os.path.exists(audio_path):
        return f"Error: File not found: {audio_path}"
    
    print(f"🎤 Loading Whisper model '{model_name}'...")
    model = whisper.load_model(model_name)
    
    print(f"🔍 Transcribing: {audio_path}")
    
    # Transcribe with language detection
    result = model.transcribe(
        audio_path,
        language=None,  # Auto-detect (Hebrew or English)
        task="transcribe",
        fp16=False  # Use FP32 for CPU compatibility
    )
    
    detected_lang = result.get("language", "unknown")
    text = result["text"].strip()
    
    print(f"\n✅ Detected language: {detected_lang}")
    print(f"📝 Transcription:\n{text}\n")
    
    return text


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 transcribe_voice.py <audio_file> [model_size]")
        print("Example: python3 transcribe_voice.py message.ogg base")
        sys.exit(1)
    
    audio_file = sys.argv[1]
    model_size = sys.argv[2] if len(sys.argv) > 2 else "small"
    
    transcribe_audio(audio_file, model_size)
