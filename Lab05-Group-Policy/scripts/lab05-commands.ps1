# =====================================================================
# Lab 05 - Group Policy: Password Policy (GPMC) and Corporate Wallpaper (PowerShell)
# Reference of the commands used in this lab.
#
# NOT meant to be run as a single script: sections run on DC01 or on
# WS02 as a domain user. The password policy was set in GPMC.
# =====================================================================


# ---------------------------------------------------------------------
# DC01 - Password policy
# ---------------------------------------------------------------------
# Set in GPMC: Default Domain Policy >
#   Computer Configuration > Policies > Windows Settings > Security Settings >
#   Account Policies > Password Policy > Minimum password length = 12

gpupdate /force
Get-ADDefaultDomainPasswordPolicy |
    Select-Object MinPasswordLength, ComplexityEnabled, PasswordHistoryCount, MaxPasswordAge, LockoutThreshold


# ---------------------------------------------------------------------
# DC01 - Corporate wallpaper GPO (PowerShell only)
# ---------------------------------------------------------------------
# The image was downloaded on the admin workstation and copied over RDP to
# C:\Windows\SYSVOL\sysvol\homelab.local\scripts (the NETLOGON share).
Test-Path "\\homelab.local\NETLOGON\corporate-wallpaper.jpg"

$gpo = "All Users - Corporate Wallpaper"
$key = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System"

# Create the GPO
New-GPO -Name $gpo -Comment "Lab 05 - Corporate wallpaper for all department users"

# Same registry values the "Desktop Wallpaper" Administrative Template writes
Set-GPRegistryValue -Name $gpo -Key $key -ValueName "Wallpaper"      -Type String -Value "\\homelab.local\NETLOGON\corporate-wallpaper.jpg"
Set-GPRegistryValue -Name $gpo -Key $key -ValueName "WallpaperStyle" -Type String -Value "4"   # 4 = Fill

# Link to the parent OU; IT, Sales and HR inherit it
New-GPLink -Name $gpo -Target "OU=Departments,OU=HOMELAB,DC=homelab,DC=local"

# Verify
Get-GPO -Name $gpo | Select-Object DisplayName, GpoStatus, CreationTime
Get-GPRegistryValue -Name $gpo -Key $key


# ---------------------------------------------------------------------
# WS02 - Verify as a department user (HOMELAB\lvargas), after a fresh sign-in
# ---------------------------------------------------------------------
gpresult /r /scope user   # lists "Sales - Map S Drive" and "All Users - Corporate Wallpaper"

Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" |
    Select-Object Wallpaper, WallpaperStyle
