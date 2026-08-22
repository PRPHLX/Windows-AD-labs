# System Configuration Tools

## Control Panel vs Settings

Windows currently has two places to change system configuration, and they overlap without being equivalent.

**Settings** is the modern interface. It covers most everyday configuration and is where Microsoft continues to move functionality.

**Control Panel** is the older interface. It still exposes options that Settings does not surface, particularly for device management, administrative tools, and legacy configuration.

For support work the practical rule is: Settings for common user-facing changes, Control Panel when the option is not exposed there. Microsoft has been migrating features from Control Panel to Settings for several Windows releases, so the split shifts between versions — worth verifying on the version in front of you rather than assuming.

Fast access:

| Tool | Run command |
|---|---|
| Control Panel | `control` |
| Settings | `ms-settings:` |
| System information | `msinfo32` |
| System configuration | `msconfig` |
| Computer management | `compmgmt.msc` |
| Local users and groups | `lusrmgr.msc` |
| Services | `services.msc` |
| Event Viewer | `eventvwr.msc` |

The `.msc` files are Microsoft Management Console snap-ins. Knowing these by name is faster than navigating menus, and it is visible competence in an interview.

## Task Manager

Task Manager shows applications and processes currently running, plus resource usage and startup configuration.

Opened with `Ctrl + Shift + Esc` — direct, unlike `Ctrl + Alt + Del` which goes through the security screen first.

What each tab is for in support work:

| Tab | Use |
|---|---|
| Processes | Find what is consuming CPU, memory, or disk |
| Performance | Overall resource graphs over time |
| App history | Resource use by application |
| Startup | Programs launching at boot — a common cause of slow startup |
| Users | Who is signed in and what they are consuming |
| Details | Process IDs, precise resource figures, per-process actions |
| Services | Running and stopped services |

The **Startup** tab is worth knowing well. "My computer is slow when it turns on" is a frequent ticket, and unnecessary startup entries are a frequent cause.

## PowerShell equivalents

Most of the above has a command-line equivalent, which is faster and works over a remote session:

```powershell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10
Get-Service | Where-Object Status -eq "Running"
Get-CimInstance Win32_StartupCommand
Get-Volume
Get-ComputerInfo
```

Being able to answer a question either way — GUI or command line — is a reasonable target while learning.
