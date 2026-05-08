# Workspace Instructions

## Obsidian Vault
The Obsidian vault is at `./obsidian-vault/`. This is a git repo synced with GitHub.

### How to save notes to Obsidian:
1. Write the markdown file directly to `./obsidian-vault/`
2. Use descriptive filenames (e.g., `2026-05-08-meeting-notes.md`)
3. After writing, sync to GitHub:
   ```bash
   cd ./obsidian-vault && git add -A && git commit -m "Add note: <title>" && git push origin main:master
   ```

### Important:
- Do NOT use the Obsidian REST API - write files directly
- Always git push after creating/editing notes
- The user's Obsidian app will auto-pull changes from GitHub
