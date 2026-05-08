---
name: backup-restore
description: Backup and restore workspace configuration files. Use when user asks to backup settings, save configuration, restore from backup, or recover workspace state.
---

# Backup & Restore Skill

## Overview

Backup and restore OpenClaw workspace configuration files to/from compressed archives.

---

## Core Files to Backup

**Essential configuration:**
- `SOUL.md` - Personality & behavior rules
- `AGENTS.md` - Agent instructions
- `USER.md` - User information
- `TOOLS.md` - Tool-specific notes
- `AUTHORIZED_CONTACTS.md` - WhatsApp whitelist
- `MFA_STATE.json` - MFA challenge state
- `ERROR_ROUTING.md` - Error handling rules
- `IDENTITY.md` - Bot identity
- `HEARTBEAT.md` - Heartbeat tasks

**Memory:**
- `memory/*.md` - Daily logs
- `MEMORY.md` - Long-term memory (if exists)

**Custom scripts:**
- `*.py` - Python scripts
- `*.sh` - Shell scripts
- `*.json` - Configuration files

---

## Usage

### Backup

Create a timestamped backup archive:

```bash
~/.openclaw/workspace/backup-skill/backup.sh
```

**Output:**
```
Created: ~/.openclaw/workspace/backups/backup-YYYY-MM-DD-HHMMSS.tar.gz
Size: X MB
Files: Y
Tokens: ~Z
```

### Restore

Restore from the latest backup:

```bash
~/.openclaw/workspace/backup-skill/restore.sh
```

Or from a specific backup:

```bash
~/.openclaw/workspace/backup-skill/restore.sh backups/backup-2026-04-21-215900.tar.gz
```

---

## Backup Location

**Default:** `~/.openclaw/workspace/backups/`

**Naming:** `backup-YYYY-MM-DD-HHMMSS.tar.gz`

---

## Token Estimation

**Typical workspace backup:**
- Configuration files: ~10-15k tokens
- Memory files: ~5-10k tokens per day
- Scripts: ~2-5k tokens
- **Total: ~20-30k tokens**

**Formula:**
```
tokens ≈ (total_chars / 4)
```

---

## Restore Options

| **Option** | **Script** | **What It Does** | **Use Case** |
|-----------|-----------|-----------------|------------|
| **1. Full Restore** | `restore.sh` | Restore everything from backup | Complete recovery |
| **2. Telegram-Only** | `restore-telegram-only.sh` | Fresh config with only Telegram enabled | Clean start, minimal setup |
| **3. Specific Backup** | `restore.sh backups/backup-YYYY-MM-DD.tar.gz` | Choose exact backup by date | Rollback to specific point |

---

## Restore Procedures

### Option 1: Full Restore (5 steps)

1. **List available backups:**
   ```bash
   ls -lh ~/.openclaw/workspace/backups/
   ```

2. **Choose backup:**
   ```bash
   BACKUP=backup-2026-04-21-215900.tar.gz
   ```

3. **Preview contents:**
   ```bash
   tar -tzf ~/.openclaw/workspace/backups/$BACKUP | head -20
   ```

4. **Restore:**
   ```bash
   ~/.openclaw/workspace/backup-skill/restore.sh backups/$BACKUP
   ```

5. **Verify:**
   ```bash
   ls -la ~/.openclaw/workspace/*.md
   ```

---

### Option 2: Telegram-Only Restore

**What it does:**
- Disables all channels except Telegram
- Keeps your workspace files (SOUL.md, AGENTS.md, etc.)
- Creates minimal OpenClaw config
- Backs up current config first

**Run:**
```bash
~/.openclaw/workspace/backup-skill/restore-telegram-only.sh
```

**Then restart:**
```bash
openclaw gateway restart
```

---

## Automation

### Daily Backup (via cron):

```bash
# Add to crontab (openclaw cron add)
0 2 * * * ~/.openclaw/workspace/backup-skill/backup.sh
```

---

## Safety

- Backups are **read-only** after creation
- Original files are **never deleted** during restore
- Restore creates `.bak` copies of existing files
- Verification checksum included

---

## Files

- `backup.sh` - Full backup script
- `restore.sh` - Full restore script
- `restore-telegram-only.sh` - Telegram-only restore
- `SKILL.md` - This documentation
