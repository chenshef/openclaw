#!/bin/bash
# Restore OpenClaw workspace from backup

set -euo pipefail

WORKSPACE="$HOME/.openclaw/workspace"
BACKUP_FILE="${1:-}"

# Help
if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <backup-file>"
    echo ""
    echo "Available backups:"
    ls -lh "$WORKSPACE/backups/" 2>/dev/null || echo "  (no backups found)"
    echo ""
    echo "Example:"
    echo "  $0 backups/backup-2026-04-21-215900.tar.gz"
    exit 1
fi

# Resolve path
if [[ "$BACKUP_FILE" != /* ]]; then
    BACKUP_FILE="$WORKSPACE/$BACKUP_FILE"
fi

# Check file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Backup file not found: $BACKUP_FILE"
    exit 1
fi

# Preview contents
echo "📦 Backup contents:"
tar -tzf "$BACKUP_FILE" | head -10
echo ""

# Confirm
read -p "Restore from $(basename $BACKUP_FILE)? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Backup existing files
BACKUP_TIMESTAMP=$(date +%Y-%m-%d-%H%M%S)
echo "🔄 Creating backup of existing files..."
for file in $(tar -tzf "$BACKUP_FILE"); do
    if [ -f "$WORKSPACE/$file" ]; then
        cp "$WORKSPACE/$file" "$WORKSPACE/$file.bak-$BACKUP_TIMESTAMP"
    fi
done

# Restore
echo "📥 Restoring..."
cd "$WORKSPACE"
tar -xzf "$BACKUP_FILE"

# Verify
FILE_COUNT=$(tar -tzf "$BACKUP_FILE" | wc -l)
echo ""
echo "✅ Restore complete!"
echo "  Files restored: $FILE_COUNT"
echo "  Location: $WORKSPACE"
echo ""
echo "Existing files backed up with extension: .bak-$BACKUP_TIMESTAMP"
