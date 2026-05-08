#!/bin/bash
cd /home/openclaw/.openclaw/workspace
source whisper_env/bin/activate
python3 transcribe_voice.py "$1"
