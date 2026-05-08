# 🔧 Google Drive Setup with rclone - Step by Step

## Option 1: Manual Setup (5 minutes) - RECOMMENDED

### Step 1: Open Terminal
```bash
rclone config
```

### Step 2: Follow these prompts EXACTLY:

```
Current remotes: (empty)

e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config

e/n/d/r/c/s/q> n          ← Type: n

Enter name for new remote.
name> gdrive               ← Type: gdrive

Option Storage.
Type of storage to configure.
Choose a number from below, or type in your own value.
...
XX / Google Drive
   \ (drive)
...
Storage> drive             ← Type: drive

Option client_id.
Google Application Client Id
Leave blank normally.
Enter a value. Press Enter to leave empty.
client_id>                 ← Press Enter (leave blank)

Option client_secret.
OAuth Client Secret.
Leave blank normally.
Enter a value. Press Enter to leave empty.
client_secret>             ← Press Enter (leave blank)

Option scope.
Scope that rclone should use when requesting access from drive.
Choose a number from below, or type in your own value.
...
 1 / Full access all files, excluding Application Data Folder.
   \ (drive)
...
scope> 1                   ← Type: 1

Option root_folder_id.
ID of the root folder.
Leave blank normally.
Enter a value. Press Enter to leave empty.
root_folder_id>            ← Press Enter (leave blank)

Option service_account_file.
Service Account Credentials JSON file path.
Leave blank normally.
Enter a value. Press Enter to leave empty.
service_account_file>      ← Press Enter (leave blank)

Edit advanced config?
y) Yes
n) No (default)
y/n> n                     ← Type: n

Use web browser to automatically authenticate rclone with remote?
 * Say Y if the machine running rclone has a web browser you can use
 * Say N if running rclone on a (remote) machine without web browser access
If not sure try Y. If Y failed, try N.

y) Yes (default)
n) No
y/n> y                     ← Type: y

```

### Step 3: Browser Opens
- A browser window will open automatically
- Log in to your Google account (chenshefking@gmail.com)
- Click "Allow" to give rclone access to Google Drive
- You'll see: "Success! You can now close this window."

### Step 4: Back in Terminal
```
Configure this as a Shared Drive (Team Drive)?

y) Yes
n) No (default)
y/n> n                     ← Type: n

Configuration complete.
Options:
- type: drive
- scope: drive
- token: {"access_token":"..."}

Keep this "gdrive" remote?
y) Yes this is OK (default)
e) Edit this remote
d) Delete this remote
y/e/d> y                   ← Type: y

Current remotes:

Name                 Type
====                 ====
gdrive               drive

e/n/d/r/c/s/q> q           ← Type: q (quit)
```

### Step 5: Test Connection
```bash
# List your Google Drive
rclone lsd gdrive:

# Create the openclaw folder
rclone mkdir "gdrive:openclaw Work products"

# Upload a test file
rclone copy test.txt "gdrive:openclaw Work products/"
```

---

## Option 2: Quick Commands (After Manual Setup)

Once rclone is configured, use these commands:

### Upload Single File
```bash
rclone copy file.docx "gdrive:openclaw Work products/"
```

### Upload Entire Folder
```bash
rclone copy /path/to/folder/ "gdrive:openclaw Work products/folder-name/"
```

### Sync Folder (two-way)
```bash
rclone sync /local/folder/ "gdrive:openclaw Work products/folder-name/"
```

### List Files
```bash
rclone ls "gdrive:openclaw Work products/"
```

---

## Option 3: Automated Script (After Manual Setup)

Create this script for future uploads:

```bash
#!/bin/bash
# upload_to_gdrive.sh

PROJECT_NAME="$1"
LOCAL_DIR="$2"

if [ -z "$PROJECT_NAME" ] || [ -z "$LOCAL_DIR" ]; then
    echo "Usage: $0 <project-name> <local-directory>"
    exit 1
fi

echo "📤 Uploading $PROJECT_NAME to Google Drive..."

rclone copy "$LOCAL_DIR" "gdrive:openclaw Work products/$PROJECT_NAME/" \
    --progress \
    --transfers 4 \
    --checkers 8 \
    --contimeout 60s \
    --timeout 300s \
    --retries 3 \
    --low-level-retries 10

if [ $? -eq 0 ]; then
    echo "✅ Upload successful!"
    echo "📁 Location: Google Drive > openclaw Work products > $PROJECT_NAME"
else
    echo "❌ Upload failed!"
    exit 1
fi
```

Usage:
```bash
chmod +x upload_to_gdrive.sh
./upload_to_gdrive.sh "pentest-suite" ~/.openclaw/workspace/pentest-suite/
```

---

## Troubleshooting

### Browser doesn't open?
```bash
# Get the URL manually
rclone config
# Copy the URL it shows and paste in browser
```

### "Failed to configure token" error?
```bash
# Try without browser auth
rclone config
# When asked "Use web browser?", type: n
# Follow the manual auth flow
```

### Test if working:
```bash
rclone about gdrive:
# Should show your Drive storage info
```

---

## For Our Pentest Suite

Once configured, upload project files:

```bash
cd ~/.openclaw/workspace/pentest-suite

# Upload main report
rclone copy comprehensive_security_report_yes.co.il.docx \
    "gdrive:openclaw Work products/pentest-suite/"

# Upload full documentation
rclone copy COMPLETE_PROJECT_DOCUMENTATION.docx \
    "gdrive:openclaw Work products/pentest-suite/"

# Upload everything
rclone copy . "gdrive:openclaw Work products/pentest-suite/" \
    --exclude "venv/**" \
    --exclude "*.pyc" \
    --exclude "__pycache__/**"
```

---

## Security Notes

✅ **OAuth tokens stored locally** at: `~/.config/rclone/rclone.conf`  
✅ **Encrypted** (you can add a password with `rclone config`)  
✅ **Revocable** any time from Google Account settings  
✅ **No password stored** - only OAuth tokens  

---

## Next Steps

1. Run `rclone config` in your terminal
2. Follow the prompts above
3. Test with `rclone lsd gdrive:`
4. Upload files!

**Estimated time:** 5 minutes  
**Difficulty:** Easy (just follow the prompts)

---

**Need help? Let me know which step you're stuck on!** 🚀
