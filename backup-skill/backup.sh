#!/bin/bash
# Backup OpenClaw workspace configuration

set -euo pipefail

WORKSPACE="$HOME/.openclaw/workspace"
BACKUP_DIR="$WORKSPACE/backups"
TIMESTAMP=$(date +%Y-%m-%d-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup-$TIMESTAMP.tar.gz"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Files to backup
FILES=(
    "SOUL.md"
    "AGENTS.md"
    "USER.md"
    "TOOLS.md"
    "AUTHORIZED_CONTACTS.md"
    "MFA_STATE.json"
    "ERROR_ROUTING.md"
    "IDENTITY.md"
    "HEARTBEAT.md"
    "memory/*.md"
)

# Optional files (if they exist)
OPTIONAL=(
    "MEMORY.md"
    "DREAMS.md"
    "*.py"
    "*.sh"
    "*.json"
)

# Build file list
FILE_LIST=""
for f in "${FILES[@]}"; do
    FILE_LIST="$FILE_LIST $f"
done

for f in "${OPTIONAL[@]}"; do
    if ls $WORKSPACE/$f 1> /dev/null 2>&1; then
        FILE_LIST="$FILE_LIST $f"
    fi
done

# Create backup
cd "$WORKSPACE"
tar -czf "$BACKUP_FILE" $FILE_LIST 2>/dev/null || true

# Calculate stats
SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
FILE_COUNT=$(tar -tzf "$BACKUP_FILE" | wc -l)
TOTAL_CHARS=$(tar -xzf "$BACKUP_FILE" -O | wc -c)
TOKENS=$((TOTAL_CHARS / 4))

# Output
echo "✅ Backup created:"
echo "  File: $BACKUP_FILE"
echo "  Size: $SIZE"
echo "  Files: $FILE_COUNT"
echo "  Tokens: ~$TOKENS"
echo ""
echo "Restore with:"
echo "  $WORKSPACE/backup-skill/restore.sh backups/backup-$TIMESTAMP.tar.gz"
