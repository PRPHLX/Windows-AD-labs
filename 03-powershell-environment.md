# PowerShell: Environment Variables and Discovery

## Reading the `$env:` syntax

```powershell
$env:SystemRoot
```

This looks like one symbol but it is three parts:

| Part | Meaning |
|---|---|
| `$` | PowerShell's variable prefix — every variable starts with it |
| `env:` | a **drive**, the same way `C:` is a drive |
| `SystemRoot` | the item being requested from that drive |

The whole expression reads as: *get the value of the item `SystemRoot` from the `Env:` drive.*

The colon is not decoration. PowerShell exposes several data stores as navigable drives through its provider model, so environment variables can be browsed like a file system:

```powershell
Get-ChildItem Env:          # list every environment variable
dir Env:                    # same thing, alias
Get-Item Env:SystemRoot     # just that one
```

The same pattern applies to the Windows registry:

```powershell
dir HKLM:\Software
Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
```

Other scope prefixes follow the same colon syntax: `$global:name`, `$script:name`.

## Writing environment variables

```powershell
$env:MY_VAR = "value"
```

This affects the current session only. It disappears when the shell closes. Persisting a variable requires `[Environment]::SetEnvironmentVariable()` or the System Properties dialog.

## Things that tripped me up

**Spaces break the name.** `$env: PATH` fails with a parser error, because the space ends the variable reference. It must be `$env:PATH`.

**Names are case-insensitive.** `$env:Systemroot`, `$env:SYSTEMROOT`, and `$env:systemroot` all work.

**A variable that does not exist returns nothing, not an error.** `$env:Users` produces empty output — there is no such variable. Silence means "not found", so it is worth confirming a name exists rather than assuming a typo:

```powershell
dir Env: | Where-Object Name -like "*user*"
```

**In paths, separate the variable from what follows.** `"$env:SystemRoot\System32"` works. For text with no separator, use braces: `"${env:SystemRoot}something"`.

## The object pipeline

The most important difference from a Unix shell: **PowerShell passes objects, not text.**

In bash, a pipeline passes strings, so tools like `grep`, `awk`, and `cut` exist to slice text back apart. In PowerShell, each item arriving in the pipeline is a .NET object with named properties, so it can be queried directly:

```powershell
dir Env: | Where-Object Name -like "*user*"
```

No text parsing needed — `Name` is a real property on the object.

`Where-Object` also accepts a script block, which allows compound conditions and any other code:

```powershell
dir Env: | Where-Object { $_.Name -like "*user*" -and $_.Value -like "C:*" }
```

`$_` is the current pipeline object.

## Two commands that replace memorization

```powershell
Get-Service | Get-Member        # every property and method on the object
Get-Help Where-Object -Examples # worked examples for any command
```

`Get-Member` is the tool for exploring anything unfamiliar. Instead of searching for which property holds the data, ask the object directly.

## Command naming

Every cmdlet follows a `Verb-Noun` pattern, and the verbs come from an approved list:

```powershell
Get-Verb                         # the official verb list
Get-Command -Noun Service        # everything operating on services
Get-Command | Measure-Object     # how many commands are available
```

The pattern makes commands guessable. Knowing the noun usually gets you to the cmdlet without a search.

## PowerShell 5.1 vs PowerShell 7

Windows ships with **Windows PowerShell 5.1** (`powershell`), built on .NET Framework and Windows-only.

**PowerShell 7** (`pwsh`) is the current cross-platform version, with additional operators and cmdlets. The two install side by side:

```powershell
winget install Microsoft.PowerShell
```

Worth knowing which one you are in when following documentation or a book — examples written for 7 can fail silently or oddly on 5.1.
