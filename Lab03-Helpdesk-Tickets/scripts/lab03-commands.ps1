# =====================================================================
# Lab 03 - Help Desk Tickets
# Reference of the PowerShell commands used in this lab.
#
# NOT meant to be run as a single script: each block belongs to a
# ticket and runs on DC01 unless marked WS02. Lines marked
# "GUI equivalent" were NOT executed in the lab; that step was done in
# ADUC or GPMC and the command is the PowerShell way to do the same.
# =====================================================================


# ---------------------------------------------------------------------
# Ticket #1 - Forgotten password (Carlos Rojas)
# ---------------------------------------------------------------------

# Verify the account state before acting
Get-ADUser crojas -Properties Enabled, LockedOut, PasswordLastSet, LastLogonDate, BadLogonCount |
    Select-Object Name, Enabled, LockedOut, PasswordLastSet, LastLogonDate, BadLogonCount

# Reset done in ADUC (Reset Password, "User must change password at next logon").
# GUI equivalent, for reference only:
# Set-ADAccountPassword crojas -Reset -NewPassword (Read-Host "New temporary password" -AsSecureString)
# Set-ADUser crojas -ChangePasswordAtLogon $true

# WS02 - confirm as the user after signing in
whoami
whoami /groups | findstr HOMELAB

# Verify the account state after the fix (same command as above)
Get-ADUser crojas -Properties Enabled, LockedOut, PasswordLastSet, LastLogonDate, BadLogonCount |
    Select-Object Name, Enabled, LockedOut, PasswordLastSet, LastLogonDate, BadLogonCount


# ---------------------------------------------------------------------
# Ticket #2 - Account lockout (Laura Vargas)
# ---------------------------------------------------------------------

# Check the domain password and lockout policy (LockoutThreshold was 0)
Get-ADDefaultDomainPasswordPolicy

# Lockout policy set in GPMC: Default Domain Policy >
#   Computer Configuration > Policies > Windows Settings > Security Settings >
#   Account Policies > Account Lockout Policy
#   Threshold 5 attempts, duration 15 min, reset counter after 15 min

# Apply and verify
gpupdate /force
Get-ADDefaultDomainPasswordPolicy

# Diagnose: every locked account in the domain, then the details
Search-ADAccount -LockedOut | Select-Object Name, SamAccountName, LockedOut

Get-ADUser lvargas -Properties LockedOut, BadLogonCount, AccountLockoutTime, LastBadPasswordAttempt |
    Select-Object Name, LockedOut, BadLogonCount, AccountLockoutTime, LastBadPasswordAttempt

# Unlock and reset done in ADUC (Reset Password + "Unlock the user's account").
# GUI equivalent, for reference only:
# Unlock-ADAccount lvargas
# Set-ADAccountPassword lvargas -Reset -NewPassword (Read-Host "New temporary password" -AsSecureString)
# Set-ADUser lvargas -ChangePasswordAtLogon $true

# Verify
Get-ADUser lvargas -Properties LockedOut, BadLogonCount | Select-Object Name, LockedOut, BadLogonCount


# ---------------------------------------------------------------------
# Ticket #3 - Offboarding (Sofia Jimenez)
# ---------------------------------------------------------------------

# Document the current state before changing anything
Get-ADUser sjimenez -Properties Enabled, Department, Description, MemberOf, DistinguishedName |
    Select-Object Name, Enabled, Department, Description, MemberOf, DistinguishedName

# "Disabled Users" OU created in ADUC under HOMELAB.
# GUI equivalent, for reference only:
# New-ADOrganizationalUnit -Name "Disabled Users" -Path "OU=HOMELAB,DC=homelab,DC=local"

# 1. Cut access immediately
Disable-ADAccount sjimenez

# 2. Replace the password with a random one that is never displayed
Set-ADAccountPassword sjimenez -Reset -NewPassword (ConvertTo-SecureString ([guid]::NewGuid().ToString() + "A!") -AsPlainText -Force)

# 3. Record when, why and which access the account had
Set-ADUser sjimenez -Description "Offboarded 2026-10-08 - Ticket #3 - Former groups: GG-HR"

# 4. Remove every group membership (Domain Users stays: it is the primary group)
Get-ADUser sjimenez -Properties MemberOf |
    Select-Object -ExpandProperty MemberOf |
    ForEach-Object { Remove-ADGroupMember -Identity $_ -Members sjimenez -Confirm:$false }

# 5. Move the account out of the department OU
Get-ADUser sjimenez | Move-ADObject -TargetPath "OU=Disabled Users,OU=HOMELAB,DC=homelab,DC=local"

# Verify
Get-ADUser sjimenez -Properties Enabled, Description, MemberOf, DistinguishedName |
    Select-Object Name, Enabled, Description, MemberOf, DistinguishedName


# ---------------------------------------------------------------------
# Ticket #4 - Onboarding (Mariana Solano)
# ---------------------------------------------------------------------

# Check that the logon name is available (no output = available)
Get-ADUser -Filter "SamAccountName -eq 'msolano'"

# Temporary password, read as a SecureString
$pass = Read-Host "Temporary password" -AsSecureString

New-ADUser -Name "Mariana Solano" -GivenName "Mariana" -Surname "Solano" `
    -SamAccountName "msolano" -UserPrincipalName "msolano@homelab.local" `
    -Title "HR Assistant" -Department "HR" `
    -Description "Onboarded 2026-10-08 - Ticket #4 - Replaces sjimenez" `
    -Path "OU=HR,OU=Departments,OU=HOMELAB,DC=homelab,DC=local" `
    -AccountPassword $pass -Enabled $true -ChangePasswordAtLogon $true

# Access by role, not copied from the previous employee
Add-ADGroupMember -Identity "GG-HR" -Members msolano

# Verify
Get-ADUser msolano -Properties Title, Department, Description, Enabled, MemberOf |
    Select-Object Name, Title, Department, Description, Enabled, MemberOf, DistinguishedName

# WS02 - confirm as the user after signing in
whoami
whoami /groups | findstr HOMELAB
