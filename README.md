# Windows & Active Directory Labs

Hands-on notes and labs on Windows administration, Active Directory, and PowerShell — built while preparing for entry-level IT support and system administration roles.

Companion repo to [Networking-labs](https://github.com/PRPHLX/Networking-labs).

## Why this repo

I'm working toward an IT support role, with a longer-term goal of moving into security operations. This repo is where I document what I learn as I learn it: the concepts, the commands that actually get used, and the labs I build to test them.

Notes are written in my own words rather than copied. When I get something wrong and correct it later, I leave the correction visible — that's part of the record.

## Labs

Each lab simulates real Desktop Support / Service Desk work and includes objective, topology, steps, verification, lessons learned, and a commands reference, with screenshots of what I actually did.

| Lab | Topic | Status |
|---|---|---|
| [Lab 01 — Domain Controller Deployment](Lab01-DC-Setup/) | Windows Server 2022 on Proxmox, VirtIO drivers, static IP, AD DS + DNS, new forest `homelab.local` | ✅ Complete |
| [Lab 02 — Domain Structure and Client Join](Lab02-Domain-Structure/) | OUs by department, users and security groups (GUI + PowerShell), joining a Windows 11 client, VirtualBox/Hyper-V troubleshooting | ✅ Complete |
| [Lab 03 — Help Desk Tickets](Lab03-Helpdesk-Tickets/) | Password reset, account lockout policy (GPO) and unlock, offboarding and onboarding | ✅ Complete |
| Lab 04 — File Shares and Mapped Drives | Shared folder with group-based permissions, drive mapping via GPO | 🔜 Planned |
| Lab 05 — Group Policy and PowerShell | Useful GPOs (wallpaper, password policy) and the same tasks in PowerShell | 🔜 Planned |

## Notes

| File | Topic |
|---|---|
| [01-windows-file-system.md](notes/01-windows-file-system.md) | NTFS, the directory structure, environment variables |
| [02-user-accounts-and-uac.md](notes/02-user-accounts-and-uac.md) | Account types, user creation, User Account Control |
| [03-powershell-environment.md](notes/03-powershell-environment.md) | The `Env:` drive, discovering commands, PowerShell vs cmd |
| [04-system-tools.md](notes/04-system-tools.md) | Control Panel, Settings, Task Manager |

## Lab environment

| Component | Role |
|---|---|
| Dell OptiPlex 7060 (i5-8500, 24 GB RAM) | Proxmox VE 9.2 host running **DC01**, a Windows Server 2022 domain controller for `homelab.local` (`192.168.100.10`), and **WS02**, a domain-joined Windows 11 Pro client |
| MSI desktop (i7-10700F, 32 GB RAM) | Admin workstation: Proxmox web UI and Remote Desktop to DC01 |

## Roadmap

- [x] Windows Fundamentals — file system, users, UAC
- [ ] Windows Fundamentals — system configuration, registry, resource monitoring
- [x] Active Directory: domain controller deployment ([Lab 01](Lab01-DC-Setup/))
- [x] Active Directory: OUs, users, groups, client domain join ([Lab 02](Lab02-Domain-Structure/))
- [x] Active Directory: help desk tickets — password reset, lockout, offboarding, onboarding ([Lab 03](Lab03-Helpdesk-Tickets/))
- [ ] Active Directory: Group Policy
- [ ] NTFS vs share permissions — hands-on comparison
- [ ] PowerShell for support tasks: account lockouts, event logs, services
- [ ] Windows Event Log analysis

## Study sources

- TryHackMe — Windows and AD Fundamentals
- *Learn PowerShell in a Month of Lunches*, 4th edition (Manning)
- Microsoft Learn documentation

---

**Note:** These are conceptual notes. No room answers, flags, or walkthrough solutions from any training platform are published here.
