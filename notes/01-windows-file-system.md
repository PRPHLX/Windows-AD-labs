# Windows File System

## NTFS

NTFS stands for **New Technology File System**. It is the default file system on modern Windows installations.

It replaced the **FAT** family (FAT16, FAT32). FAT32 is still common on USB drives, SD cards, and other removable media, mostly because it is readable by almost every operating system. Its main limits are a 4 GB maximum file size and no permission model.

NTFS is not just a way of naming folders — it defines how data is physically stored on the disk, and it adds features FAT never had:

| Feature | What it does |
|---|---|
| Permissions (ACLs) | Controls which users and groups can read, write, or execute a file |
| Journaling | Keeps a log of pending changes so the volume can recover after a crash |
| Encryption (EFS) | Encrypts files at the file system level |
| Compression | Compresses files transparently |
| Large file support | No practical 4 GB limit |

The permission model is the part that matters most in support work. Most "I can't open this folder" tickets end up being an NTFS permission problem.

## Directory structure

User folders live under `C:\Users`. Each user account gets its own folder there, containing the default profile folders:

```
C:\Users\<username>\
├── Desktop
├── Documents
├── Downloads
├── Music
├── Pictures
├── Videos
└── AppData        (hidden — application settings and cache)
```

`AppData` is hidden by default and holds per-user application data. It splits into `Roaming` (follows the user across machines in a domain) and `Local` (stays on that machine). This distinction matters in environments with roaming profiles.

## Environment variables

Environment variables are named values the system uses to point at important locations, so software does not have to hardcode paths. Useful because paths differ between machines and Windows versions.

Common ones:

| Variable | Typical value |
|---|---|
| `SystemRoot` | `C:\Windows` |
| `USERPROFILE` | `C:\Users\<username>` |
| `USERNAME` | the logged-in account name |
| `APPDATA` | `C:\Users\<username>\AppData\Roaming` |
| `LOCALAPPDATA` | `C:\Users\<username>\AppData\Local` |
| `ProgramFiles` | `C:\Program Files` |
| `ProgramData` | `C:\ProgramData` |
| `TEMP` | the current user's temp folder |

### The syntax differs by shell

**Command Prompt (cmd)** wraps the name in percent signs. The shell substitutes the text before running the line:

```cmd
echo %SystemRoot%
cd %USERPROFILE%
```

**PowerShell** uses `$env:` instead:

```powershell
$env:SystemRoot
cd $env:USERPROFILE
```

These are not interchangeable. Typing `%SystemRoot%` in PowerShell returns the literal text `%SystemRoot%`, because PowerShell has no percent-sign substitution — it treats that as an ordinary string.

If you need to expand cmd-style syntax from inside PowerShell:

```powershell
[System.Environment]::ExpandEnvironmentVariables("%SystemRoot%\System32")
```

### Note on folders without a variable

There is no environment variable for `C:\Users` itself. To get there, go up one level from the profile path:

```powershell
Split-Path $env:USERPROFILE      # C:\Users
```

Special folders like Desktop and Documents also have no environment variable, and their names change with the Windows display language or when redirected to OneDrive. The reliable way to reference them:

```powershell
[Environment]::GetFolderPath('Desktop')
[Environment]::GetFolderPath('MyDocuments')
```
