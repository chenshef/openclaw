#!/bin/bash
# Switch configuration profiles (1, 2, or 3)

set -euo pipefail

PROFILE_NUM="${1:-}"
PROFILES_DIR="$HOME/.openclaw/workspace/config-profiles"
WORKSPACE="$HOME/.openclaw/workspace"

# Help
if [ -z "$PROFILE_NUM" ]; then
    echo "Usage: $0 <1|2|3>"
    echo ""
    echo "Available profiles:"
    echo "  1 - WhatsApp: Chen Only (max security)"
    echo "  2 - WhatsApp: Full Family + MFA"
    echo "  3 - Telegram Only"
    echo ""
    echo "Example:"
    echo "  $0 1  # Switch to Chen Only"
    echo "  $0 2  # Switch to Full Family"
    echo "  $0 3  # Switch to Telegram Only"
    exit 1
fi

# Validate profile number
if [[ ! "$PROFILE_NUM" =~ ^[1-3]$ ]]; then
    echo "❌ Invalid profile number: $PROFILE_NUM"
    echo "   Valid options: 1, 2, 3"
    exit 1
fi

# Map profile number to file
case "$PROFILE_NUM" in
    1) PROFILE_FILE="$PROFILES_DIR/1-whatsapp-chen-only.json" ;;
    2) PROFILE_FILE="$PROFILES_DIR/2-whatsapp-full.json" ;;
    3) PROFILE_FILE="$PROFILES_DIR/3-telegram-only.json" ;;
esac

# Check file exists
if [ ! -f "$PROFILE_FILE" ]; then
    echo "❌ Profile file not found: $PROFILE_FILE"
    exit 1
fi

# Preview
echo "📋 Profile $PROFILE_NUM: $(jq -r '.profile_name' "$PROFILE_FILE")"
echo ""
jq -r '.description' "$PROFILE_FILE"
echo ""

# Confirm
read -p "Switch to Profile $PROFILE_NUM? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Backup current config
echo "💾 Creating backup..."
"$WORKSPACE/backup-skill/backup.sh" > /dev/null 2>&1

# Apply profile
echo "🔄 Switching to Profile $PROFILE_NUM..."
cp "$PROFILE_FILE" "$WORKSPACE/.current-profile.json"

echo ""
echo "✅ Switched to Profile $PROFILE_NUM"
echo ""
echo "📋 Profile: $(jq -r '.profile_name' "$PROFILE_FILE")"
echo ""
echo "⚠️  NOTE: Workspace files updated. Restart bot for changes to take effect."
echo ""
echo "To revert:"
echo "  $WORKSPACE/backup-skill/restore.sh backups/backup-*.tar.gz"
