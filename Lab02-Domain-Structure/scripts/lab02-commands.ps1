# =====================================================================
# Lab 02 - Domain Structure, Users, Groups and Client Domain Join
# Reference of the PowerShell commands used in this lab.
#
# NOT meant to be run as a single script: each section runs on a
# different machine (DC01 or WS02), and some steps were done in the
# GUI. Lines marked "GUI equivalent" were NOT executed in the lab;
# they are the PowerShell version of a step done through the GUI.
# =====================================================================


# ---------------------------------------------------------------------
# DC01 - OU structure
# Done in ADUC (GUI). PowerShell equivalent, for reference only:
# ---------------------------------------------------------------------
# New-ADOrganizationalUnit -Name "HOMELAB"      -Path "DC=homelab,DC=local"
# New-ADOrganizationalUnit -Name "Departments"  -Path "OU=HOMELAB,DC=homelab,DC=local"
# New-ADOrganizationalUnit -Name "IT"           -Path "OU=Departments,OU=HOMELAB,DC=homelab,DC=local"
# New-ADOrganizationalUnit -Name "Sales"        -Path "OU=Departments,OU=HOMELAB,DC=homelab,DC=local"
# New-ADOrganizationalUnit -Name "HR"           -Path "OU=Departments,OU=HOMELAB,DC=homelab,DC=local"
# New-ADOrganizationalUnit -Name "Groups"       -Path "OU=HOMELAB,DC=homelab,DC=local"
# New-ADOrganizationalUnit -Name "Workstations" -Path "OU=HOMELAB,DC=homelab,DC=local"


# ---------------------------------------------------------------------
# DC01 - Users (Ana Mora was created in the GUI; the rest in PowerShell)
# ---------------------------------------------------------------------

# Temporary password, read as a SecureString (never shown or stored in history)
$pass = Read-Host "Temporary password" -AsSecureString

# Base path of the department OUs
$ou = "OU=Departments,OU=HOMELAB,DC=homelab,DC=local"

New-ADUser -Name "Carlos Rojas" -GivenName "Carlos" -Surname "Rojas" -SamAccountName "crojas" -UserPrincipalName "crojas@homelab.local" -Department "Sales" -Path "OU=Sales,$ou" -AccountPassword $pass -Enabled $true -ChangePasswordAtLogon $true
New-ADUser -Name "Laura Vargas" -GivenName "Laura" -Surname "Vargas" -SamAccountName "lvargas" -UserPrincipalName "lvargas@homelab.local" -Department "Sales" -Path "OU=Sales,$ou" -AccountPassword $pass -Enabled $true -ChangePasswordAtLogon $true
New-ADUser -Name "Sofia Jimenez" -GivenName "Sofia" -Surname "Jimenez" -SamAccountName "sjimenez" -UserPrincipalName "sjimenez@homelab.local" -Department "HR" -Path "OU=HR,$ou" -AccountPassword $pass -Enabled $true -ChangePasswordAtLogon $true

# Add the department to the user created in the GUI
Set-ADUser amora -Department "IT"

# Verify
Get-ADUser -Filter * -SearchBase $ou -Properties Department | Select-Object Name, SamAccountName, Department, Enabled | Format-Table -AutoSize


# ---------------------------------------------------------------------
# DC01 - Security groups
# ---------------------------------------------------------------------
$groups = "OU=Groups,OU=HOMELAB,DC=homelab,DC=local"

New-ADGroup -Name "GG-IT"    -GroupScope Global -GroupCategory Security -Path $groups -Description "All IT department users"
New-ADGroup -Name "GG-Sales" -GroupScope Global -GroupCategory Security -Path $groups -Description "All Sales department users"
New-ADGroup -Name "GG-HR"    -GroupScope Global -GroupCategory Security -Path $groups -Description "All HR department users"

Add-ADGroupMember -Identity "GG-IT"    -Members amora
Add-ADGroupMember -Identity "GG-Sales" -Members crojas, lvargas
Add-ADGroupMember -Identity "GG-HR"    -Members sjimenez

# Verify: one row per group with its members
Get-ADGroup -Filter 'Name -like "GG-*"' -SearchBase $groups | ForEach-Object {
    [PSCustomObject]@{
        Group   = $_.Name
        Members = (Get-ADGroupMember $_ | Select-Object -ExpandProperty SamAccountName) -join ", "
    }
} | Format-Table -AutoSize


# ---------------------------------------------------------------------
# DC01 - Prepare the DC for clients
# ---------------------------------------------------------------------

# Check existing forwarders first (the router was already configured during promotion)
Get-DnsServerForwarder

# Add the router as a DNS forwarder (returned a "already configured" warning in this lab)
Add-DnsServerForwarder -IPAddress 192.168.100.1 -PassThru

# Verify that the DC resolves internet names
Resolve-DnsName google.com

# Send newly joined computers to the Workstations OU instead of the Computers container
redircmp "OU=Workstations,OU=HOMELAB,DC=homelab,DC=local"


# ---------------------------------------------------------------------
# WS02 - Point DNS to the domain controller (run as administrator)
# ---------------------------------------------------------------------
ipconfig /all
Get-NetAdapter

Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 192.168.100.10

# Verify name resolution and the DC locator SRV record
nslookup homelab.local
nslookup -type=SRV _ldap._tcp.dc._msdcs.homelab.local
ping dc01.homelab.local
nslookup google.com


# ---------------------------------------------------------------------
# WS02 - Join the domain
# Done in the GUI (sysdm.cpl). PowerShell equivalent, for reference only:
# ---------------------------------------------------------------------
# Add-Computer -DomainName "homelab.local" -Credential "HOMELAB\Administrator" -Restart


# ---------------------------------------------------------------------
# WS02 - Verify the domain user session (signed in as HOMELAB\amora)
# ---------------------------------------------------------------------
whoami
whoami /groups | findstr HOMELAB
$env:LOGONSERVER


# ---------------------------------------------------------------------
# DC01 - Verify the first-logon password change
# (Get-ADUser is not available on WS02: the AD module is part of RSAT)
# ---------------------------------------------------------------------
Get-ADUser amora -Properties PasswordLastSet, PasswordExpired | Select-Object Name, PasswordLastSet, PasswordExpired
