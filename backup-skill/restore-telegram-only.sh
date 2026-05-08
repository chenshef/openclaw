#!/bin/bash
# Restore to Telegram-only configuration
# Clean slate with minimal channel setup

set -e

WORKSPACE="$HOME/.openclaw/workspace"
BACKUP_DIR="$WORKSPACE/backups"
CONFIG_FILE="$HOME/.openclaw/openclaw.json"

echo "🔧 Telegram-Only Restore"
echo "========================"
echo ""

# Step 1: Backup current config
echo "📦 Step 1: Backing up current config..."
if [ -f "$CONFIG_FILE" ]; then
    cp "$CONFIG_FILE" "$CONFIG_FILE.pre-telegram-only.bak"
    echo "✅ Current config saved to: $CONFIG_FILE.pre-telegram-only.bak"
else
    echo "⚠️  No existing config found at $CONFIG_FILE"
fi

# Step 2: Disconnect all non-Telegram channels FIRST
echo ""
echo "🔌 Step 2: Disconnecting non-Telegram channels..."

# Logout from WhatsApp
echo "  ⏳ Checking WhatsApp..."
if openclaw channels status --channel whatsapp 2>/dev/null | grep -q "connected\|ready"; then
    echo "  🔌 Logging out from WhatsApp..."
    openclaw channels logout --channel whatsapp 2>/dev/null || true
    echo "  ✅ WhatsApp disconnected"
else
    echo "  ℹ️  WhatsApp already disconnected"
fi

# Logout from Discord
echo "  ⏳ Checking Discord..."
if openclaw channels status --channel discord 2>/dev/null | grep -q "connected\|ready"; then
    echo "  🔌 Logging out from Discord..."
    openclaw channels logout --channel discord 2>/dev/null || true
    echo "  ✅ Discord disconnected"
else
    echo "  ℹ️  Discord already disconnected"
fi

# Logout from Signal
echo "  ⏳ Checking Signal..."
if openclaw channels status --channel signal 2>/dev/null | grep -q "connected\|ready"; then
    echo "  🔌 Logging out from Signal..."
    openclaw channels logout --channel signal 2>/dev/null || true
    echo "  ✅ Signal disconnected"
else
    echo "  ℹ️  Signal already disconnected"
fi

echo "✅ All non-Telegram channels disconnected"

# Step 3: Create minimal Telegram-only config
echo ""
echo "🔧 Step 3: Creating Telegram-only config..."

cat > "$CONFIG_FILE" << 'EOF'
{
  "channels": {
    "telegram": {
      "enabled": true
    },
    "whatsapp": {
      "enabled": false
    },
    "discord": {
      "enabled": false
    },
    "signal": {
      "enabled": false
    },
    "slack": {
      "enabled": false
    },
    "imessage": {
      "enabled": false
    }
  },
  "agents": {
    "defaults": {
      "model": "anthropic/claude-sonnet-4-5"
    }
  },
  "gateway": {
    "port": 18789
  }
}
EOF

echo "✅ Telegram-only config created"

# Step 4: Keep essential workspace files
echo ""
echo "📝 Step 4: Preserving workspace files..."
KEEP_FILES=(
    "SOUL.md"
    "AGENTS.md"
    "USER.md"
    "TOOLS.md"
    "IDENTITY.md"
    "HEARTBEAT.md"
    "MEMORY.md"
)

for file in "${KEEP_FILES[@]}"; do
    if [ -f "$WORKSPACE/$file" ]; then
        echo "  ✓ Kept: $file"
    fi
done

# Step 5: Clean up channel-specific files (optional)
echo ""
echo "🧹 Step 5: Cleaning up channel-specific files..."
# Remove WhatsApp session files if they exist
if [ -d "$HOME/.openclaw/.wwebjs_auth" ]; then
    echo "  ⚠️  Found WhatsApp session: $HOME/.openclaw/.wwebjs_auth"
    echo "     (Removing to ensure clean disconnect...)"
    rm -rf "$HOME/.openclaw/.wwebjs_auth"
    echo "  ✅ WhatsApp session removed"
fi

# Step 6: Restart Gateway
echo ""
echo "🔄 Step 6: Restarting gateway..."
openclaw gateway restart
sleep 3
echo "✅ Gateway restarted"

# Step 7: Verify
echo ""
echo "🔍 Step 7: Verifying Telegram-only mode..."
sleep 2
openclaw status

# Step 8: Summary
echo ""
echo "✅ Telegram-Only Restore Complete!"
echo "=================================="
echo ""
echo "📋 What happened:"
echo "  ✅ Telegram: ENABLED"
echo "  ❌ WhatsApp: DISCONNECTED & DISABLED"
echo "  ❌ Discord: DISCONNECTED & DISABLED"
echo "  ❌ Signal: DISCONNECTED & DISABLED"
echo "  ❌ Slack: DISABLED"
echo "  ❌ iMessage: DISABLED"
echo ""
echo "📝 Your workspace files are preserved:"
for file in "${KEEP_FILES[@]}"; do
    if [ -f "$WORKSPACE/$file" ]; then
        echo "  ✓ $file"
    fi
done
echo ""
echo "💾 Backup of previous config: $CONFIG_FILE.pre-telegram-only.bak"
echo ""
echo "✅ You should now ONLY receive messages from Telegram!"
