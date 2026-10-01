# User Accounts and User Account Control

## Account types

Windows has two main local account types:

**Administrator** — can install software, change system settings, modify other accounts, and access protected system locations.

**Standard user** — can run applications and change settings that affect only their own account. Anything system-wide requires administrator approval.

The security principle behind this split is **least privilege**: an account should hold only the permissions it needs for normal work. If a standard user's session is compromised, the attacker inherits only standard-user permissions.

## Viewing and managing users

Through the graphical interface, search for **"Other users"** in the Start menu search box. The exact wording and appearance change between Windows versions and editions, so the path is not identical everywhere.

From that screen, an administrator sees the option to add a new account. A standard user does not.

### Detail worth remembering

When a new user is created, the account exists but the profile folder under `C:\Users` is **not created until that user signs in for the first time**. Windows builds the profile — Desktop, Documents, Downloads, and the rest — during that first login.

This explains a real support scenario: you create an account, go look for its folder, and it is not there. Nothing is broken. The user just has not logged in yet.

### From the command line

```powershell
Get-LocalUser                              # list local accounts
Get-LocalUser | Select-Object Name, Enabled, LastLogon
Get-LocalGroupMember Administrators        # who has admin rights
```

Checking group membership is often the fastest way to answer "why can this person do that?"

## User Account Control (UAC)

UAC was introduced in **Windows Vista** and remains in current versions.

### What problem it solves

Before UAC, an account in the Administrators group ran everything with full administrative rights all the time. That meant any program the user launched — including malware — inherited administrator privileges automatically, with no prompt and no barrier.

### How it works

Under UAC, an administrator account runs normally with a **filtered token**, holding standard-user privileges. When a program needs elevated rights, Windows interrupts and asks for confirmation. Privilege is granted per action, not held permanently.

The prompt itself is the security control. It moves a silent privilege escalation into a visible decision the user has to make.

### Visual indicators

Applications that require elevation are marked with a **shield icon**. Comparing an elevated process against a non-elevated one shows the difference in what each can reach — an unelevated editor cannot save into `C:\Windows`, for example, while an elevated one can.

To check your own privileges in the current session:

```powershell
whoami /priv
whoami /groups
```

### Note

UAC is a barrier, not a wall. It reduces accidental and automated privilege escalation; it is not designed to stop a determined attacker who already has code execution. Useful to state accurately — overstating what a control does is its own kind of error.
