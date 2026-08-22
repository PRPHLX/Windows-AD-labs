# Windows & Active Directory Labs

Hands-on notes and labs on Windows administration, Active Directory, and PowerShell — built while preparing for entry-level IT support and system administration roles.

Companion repo to [Networking-labs](https://github.com/Cap1919/Networking-labs).

## Why this repo

I'm working toward an IT support role, with a longer-term goal of moving into security operations. This repo is where I document what I learn as I learn it: the concepts, the commands that actually get used, and the labs I build to test them.

Notes are written in my own words rather than copied. When I get something wrong and correct it later, I leave the correction visible — that's part of the record.

## Contents

| File | Topic |
|---|---|
| [01-windows-file-system.md](01-windows-file-system.md) | NTFS, the directory structure, environment variables |
| [02-user-accounts-and-uac.md](02-user-accounts-and-uac.md) | Account types, user creation, User Account Control |
| [03-powershell-environment.md](03-powershell-environment.md) | The `Env:` drive, discovering commands, PowerShell vs cmd |
| [04-system-tools.md](04-system-tools.md) | Control Panel, Settings, Task Manager |

## Roadmap

- [x] Windows Fundamentals — file system, users, UAC
- [ ] Windows Fundamentals — system configuration, registry, resource monitoring
- [ ] Active Directory lab: domain controller, OUs, users, group policy
- [ ] NTFS vs share permissions — hands-on comparison
- [ ] PowerShell for support tasks: account lockouts, event logs, services
- [ ] Windows Event Log analysis

## Lab environment

Planned setup: VirtualBox with a Windows Server evaluation instance as domain controller and a Windows 11 client joined to the domain. Screenshots and configuration notes will be added as the lab is built.

## Study sources

- TryHackMe — Windows and AD Fundamentals
- *Learn PowerShell in a Month of Lunches*, 4th edition (Manning)
- Microsoft Learn documentation

---

**Note:** These are conceptual notes. No room answers, flags, or walkthrough solutions from any training platform are published here.
