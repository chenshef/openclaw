#!/bin/bash
# Apply a configuration profile

set -euo pipefail

PROFILE="${1:-}"
PROFILES_DIR="$HOME/.openclaw/workspace/config-profiles"
WORKSPACE="$HOME/.openclaw/workspace"

# Help
if [ -z "$PROFILE" ]; then
    echo "Usage: $0 <profile-name>"
    echo ""
    echo "Available profiles:"
    ls -1 "$PROFILES_DIR"/*.json | xargs -n1 basename | sed 's/.json$//' | sed 's/^/  - /'
    echo ""
    echo "Example:"
    echo "  $0 whatsapp-full"
    echo "  $0 telegram-only"
    exit 1
fi

PROFILE_FILE="$PROFILES_DIR/$PROFILE.json"

# Check file exists
if [ ! -f "$PROFILE_FILE" ]; then
    echo "❌ Profile not found: $PROFILE"
    echo ""
    echo "Available profiles:"
    ls -1 "$PROFILES_DIR"/*.json | xargs -n1 basename | sed 's/.json$//' | sed 's/^/  - /'
    exit 1
fi

# Preview
echo "📋 Profile: $PROFILE"
echo ""
jq -r '.description' "$PROFILE_FILE"
echo ""

# Confirm
read -p "Apply this profile? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Backup current config
echo "💾 Creating backup..."
"$WORKSPACE/backup-skill/backup.sh" > /dev/null 2>&1

# Apply profile
echo "🔄 Applying profile..."

# Extract configuration and update files
# (This is a placeholder - actual implementation would parse JSON and update workspace files)

# For now, just copy the profile as reference
cp "$PROFILE_FILE" "$WORKSPACE/.current-profile.json"

echo ""
echo "✅ Profile applied: $PROFILE"
echo ""
echo "⚠️  NOTE: You need to manually update workspace files based on this profile."
echo "    See: $WORKSPACE/.current-profile.json"
echo ""
echo "To revert:"
echo "  $WORKSPACE/backup-skill/restore.sh backups/backup-*.tar.gz"
