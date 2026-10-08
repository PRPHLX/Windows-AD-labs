# =====================================================================
# Lab 04 - Shared Folder with Group-Based Permissions and a GPO-Mapped Drive
# Reference of the commands used in this lab.
#
# NOT meant to be run as a single script: the first section runs on
# DC01 and the tests run on WS02 as different users. The GPO was
# created and configured in GPMC (see the README).
# =====================================================================


# ---------------------------------------------------------------------
# DC01 - Folder, share and permissions
# ---------------------------------------------------------------------

# Folder on disk
New-Item -Path "C:\Shares\Sales" -ItemType Directory

# Share permissions: broad on purpose; NTFS does the real access control
New-SmbShare -Name "Sales" -Path "C:\Shares\Sales" `
    -FullAccess "BUILTIN\Administrators" `
    -ChangeAccess "NT AUTHORITY\Authenticated Users"

# NTFS permissions:
#   /inheritance:r  remove permissions inherited from C:\
#   /grant:r        replace existing grants for these principals
#   (OI)(CI)        apply to files and subfolders created inside
#   F = Full control, M = Modify
icacls "C:\Shares\Sales" /inheritance:r /grant:r `
    "BUILTIN\Administrators:(OI)(CI)F" `
    "NT AUTHORITY\SYSTEM:(OI)(CI)F" `
    "HOMELAB\GG-Sales:(OI)(CI)M"

# Verify both layers
Get-SmbShareAccess -Name "Sales"
icacls "C:\Shares\Sales"


# ---------------------------------------------------------------------
# DC01 - GPO (configured in GPMC)
# ---------------------------------------------------------------------
# GPO "Sales - Map S Drive", linked to OU=Sales,OU=Departments,OU=HOMELAB
# User Configuration > Preferences > Windows Settings > Drive Maps
#   Action: Update | Location: \\dc01.homelab.local\Sales
#   Reconnect: Yes | Label: Sales | Drive letter: S:


# ---------------------------------------------------------------------
# WS02 - Test as a Sales user (HOMELAB\crojas), after a fresh sign-in
# ---------------------------------------------------------------------
gpresult /r /scope user   # GPO "Sales - Map S Drive" should be listed
net use                   # S: -> \\dc01.homelab.local\Sales

# If the drive is missing: refresh policy, then sign out and back in
# gpupdate /force


# ---------------------------------------------------------------------
# WS02 - Test as an HR user (HOMELAB\msolano)
# ---------------------------------------------------------------------
# No S: drive expected. Opening \\dc01.homelab.local\Sales in File
# Explorer returns "You do not have permission to access" (NTFS).
