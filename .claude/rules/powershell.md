# PowerShell Rules for Ven0m0/Win

Applies to all PowerShell files: `Scripts/**/*.ps1`, `*.psm1`, `*.psd1`, and setup scripts.

Based on the [PowerShell Practice and Style guide](https://github.com/PoshCode/PowerShellPracticeAndStyle). Repo convention wins where the two disagree (see Indentation).

---

## 1. Naming Conventions

### Commands and Parameters

- Use `Verb-Noun` convention for all functions; run `Get-Verb` for the approved verb list
- PascalCase for **all** public identifiers: module names, function names, class names, parameters, global variables
- Nouns must be **singular** and may be compound-word PascalCase (`Get-DiskInfo`, not `Get-DiskInfos`)
- Two-letter acronyms keep both letters uppercase in PascalCase: `Get-PSDrive`, `$PSBoundParameters` — this does not extend to "OK"/"ID" (common words, not acronyms) or to compound acronyms (`Start-AzureRmVM`, not `Start-AzureRMVM`)
- Use full cmdlet names — no aliases (`Get-ChildItem`, not `gci`/`ls`/`dir`)
- Use full parameter names — no positional shorthand (`Get-Process -Name Explorer`, not `Get-Process Explorer`)
- Match standard PowerShell parameter names: `$ComputerName`, `$Path`, `$Credential`

### Variables

- Script-level private variables may use camelCase to distinguish from PascalCase parameters; a camelCase variable starting with a two-letter acronym lowercases both letters (`adComputer`, not `ADComputer`)
- Scope shared variables explicitly: `$Script:State`, `$Global:DebugPreference`
- PowerShell language keywords are **lowercase**: `foreach`, `if`, `switch`, `-eq`, `-match`
- Comment-based help keywords are **UPPERCASE**: `.SYNOPSIS`, `.DESCRIPTION`, `.EXAMPLE`

### Paths

- Always use `$PSScriptRoot` for script-relative paths; never unanchored `.\` or `..\`
- Use `$HOME` or `$env:USERPROFILE` for user home — never hardcode `C:\Users\...`
- Never use `~`: its meaning depends on the current provider
- Prefer `Join-Path -Path $PSScriptRoot -ChildPath ...` over string concatenation for multi-segment paths; pass fully-resolved paths to .NET methods and native apps, which don't see PowerShell's `$PWD`

```powershell
# Wrong
Get-Content .\README.md

# Right
Get-Content -Path (Join-Path -Path $PSScriptRoot -ChildPath 'README.md')
```

---

## 2. Code Layout and Formatting

### Braces — One True Brace Style (OTBS)

Opening brace at the **end** of the line; closing brace at the **beginning** of a line. This is required, not just preferred, once a scriptblock parameter like `Where-Object {}` is involved — apply it everywhere for consistency.

```powershell
if ($condition) {
  Do-Something
} else {
  Do-Other
}
```

### Indentation

**2-space** indentation (matches existing codebase style). The community default is 4-space, but the style guide itself says project convention wins — consistency with existing code takes priority here.

### Line Length

Keep lines to **115 characters** maximum. Use **splatting** instead of backtick continuation:

```powershell
# Wrong — backtick is fragile
Get-WmiObject -Class Win32_LogicalDisk `
              -Filter "DriveType=3"

# Right — splatting
$params = @{
  Class  = 'Win32_LogicalDisk'
  Filter = 'DriveType=3'
}
Get-WmiObject @params
```

String concatenation across parens also avoids backticks:

```powershell
Write-Verbose -Message ("First part of a long message. " +
  "Second part, still readable, still one string.")
```

### Whitespace

- Single space around operators, parameter names, commas, and semicolons
- Single space inside `$( ... )` subexpression and `{ ... }` scriptblock delimiters; no space inside `( ... )` parens or `[ ... ]` brackets otherwise
- No space around unary operators: `(Get-Date).AddDays(-1)`, `$i++` — not `AddDays( - 1)` / `$i ++`
- No trailing whitespace on any line
- No semicolons as line terminators
- Two blank lines between top-level function/class definitions; one blank line between methods inside a class
- One blank line at the end of each file

---

## 3. Function Structure

### Always Start With CmdletBinding

```powershell
[CmdletBinding()]
param ()
process {
}
end {
}
```

Keep `param()`, `begin`, `process`, `end` in that order — it matches execution order and keeps intent clear.

### Simple (non-advanced) Functions

Leave a space between the function name and the parameter list: `function Test-Code ($ParamOne, $ParamTwo) {`.

### No `return` in Advanced Functions

Do not use `return` to emit objects — place the object on its own line inside `process {}`, not `begin {}`/`end {}` (defeats the pipeline).

### OutputType

Declare `[OutputType()]` on every advanced function that returns objects. If output differs by parameter set, declare one `[OutputType()]` per `ParameterSetName`, and set `DefaultParameterSetName` in `[CmdletBinding()]` whenever more than one parameter set exists.

### SupportsShouldProcess

Add `SupportsShouldProcess` to any function that modifies system state:

```powershell
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param (...)
process {
  if ($PSCmdlet.ShouldProcess($Target, 'Delete')) {
    Remove-Item -Path $Target
  }
}
```

`ConfirmImpact` levels: `Low` (create/set), `Medium` (restart/reconfigure), `High` (delete/irreversible).

### Parameter Validation

Validate in the parameter block, not the function body:

| Attribute | Purpose |
| --- | --- |
| `[AllowNull()]` / `[AllowEmptyString()]` / `[AllowEmptyCollection()]` | Permit null/empty on an otherwise-mandatory parameter |
| `[ValidateNotNull()]` / `[ValidateNotNullOrEmpty()]` | Reject null/empty values |
| `[ValidateSet('A','B')]` | Restrict to an explicit list |
| `[ValidateRange(0,10)]` | Numeric bounds |
| `[ValidateCount(1,5)]` / `[ValidateLength(1,10)]` | Collection size / string length bounds |
| `[ValidatePattern('regex')]` | Regex match |
| `[ValidateScript({ ... })]` | Arbitrary validation logic against `$_` |

Strongly type every parameter; avoid `[string]`/`[object]`/`[PSObject]` on parameters used for parameter-set disambiguation or `ValueFromPipeline` — PowerShell coerces everything to them, defeating the purpose. Switch parameters never take a default value (always false) and are never treated as three-state.

---

## 4. Documentation and Comments

- Every function gets comment-based help: `.SYNOPSIS` (required), `.DESCRIPTION`, `.EXAMPLE` (at least one, code first, explanation after), `.PARAMETER` per parameter, `.OUTPUTS`, `.NOTES` as needed
- Place the help block **inside** the function, at the top, above `param()` — easiest to keep in sync
- Prefer a one-line comment directly above each parameter over `.PARAMETER` blocks — harder to forget to update when the parameter changes
- Comments explain **why**, not what — well-written PowerShell is self-explanatory
- Inline comments: at least two spaces before the `#`, aligned with sibling comments in the same block
- Block comments: one `#` + one space per line; use `<# ... #>` only for long blocks (e.g. comment-based help), with the delimiters on their own lines

```powershell
function Get-Example {
  <#
  .SYNOPSIS
    One-line description.
  .PARAMETER Name
    Description of Name.
  .EXAMPLE
    Get-Example -Name Test
    Explains what this does.
  #>
  [CmdletBinding()]
  param (
    # Description of Name, right above the parameter it documents
    [string]$Name
  )
}
```

---

## 5. Error Handling

- `$ErrorActionPreference = 'Stop'` at the top of every script
- Use `try/catch` with `-ErrorAction Stop` on cmdlets you want to trap; for non-cmdlets, set `$ErrorActionPreference` around the call and restore it after
- Put the whole transaction inside `try {}` rather than setting a `$continue`-style flag in `catch` and branching on it afterward
- Never use global `$ErrorActionPreference = 'SilentlyContinue'`
- Avoid `$?` as an error check — it only reflects whether the last command considered itself successful, with no detail
- Avoid testing a null variable as your only error condition; prefer a trappable terminating exception where the command supports one
- Copy `$_` (or `$Error[0]`) immediately inside `catch` before any subsequent command overwrites it

```powershell
catch {
  $err = $_
  Write-Warning "Failed: $($err.Exception.Message)"
}
```

---

## 6. Security — Prohibited Patterns

- `$ErrorActionPreference = 'SilentlyContinue'` globally — hides failures
- `Invoke-Expression` with variable or user-derived input — code injection risk
- Plain-string passwords in variables or parameters — accept `[PSCredential]` and decorate with `[System.Management.Automation.Credential()]`; never call `Get-Credential` inside the function itself
- `ConvertTo-SecureString -AsPlainText` with literal key material
- Global aliases in script/module scope
- `-Password` / `-Username` plain-string parameters — use `[PSCredential]`
- Hardcoded user paths `C:\Users\...` — use `$HOME`, `$env:USERPROFILE`, `$PSScriptRoot`
- Bare `curl` in PowerShell — use `curl.exe`
- Touching `HKLM\SECURITY`, `HKLM\SAM`, `HKLM\SYSTEM\...\Lsa`

Persisted credentials/secrets: `Export-Clixml`/`Import-Clixml` (DPAPI-protected, current user + machine only), not a hand-rolled `ConvertTo-SecureString -Key`.

---

## 7. Output and Streams

| Stream   | Cmdlet               | When to use                                                            |
| -------- | --------------------- | ----------------------------------------------------------------------- |
| Success  | pipeline (implicit)  | Results consumed by callers                                            |
| Verbose  | `Write-Verbose`      | Execution status; enabled by `-Verbose`                                |
| Debug    | `Write-Debug`        | Maintainer-facing detail; enabled by `-Debug`                           |
| Warning  | `Write-Warning`      | Non-fatal conditions                                                    |
| Error    | `Write-Error`        | Recoverable errors                                                      |
| Progress | `Write-Progress`     | Ephemeral status only — never the only place a needed result is shown  |
| Host     | `Write-Host`         | Interactive UI only                                                     |

- Do not use `Write-Host` for general output. Use `Write-Verbose`/`Write-Warning`/`Write-Error`
- Output one object type per function (or types sharing a common base/format); mixing types breaks table formatting. Internal-only helper functions may return mixed types since nothing formats them for a user

---

## 8. Performance

- `$null = <expr>` preferred over `<expr> | Out-Null` (pipeline form is significantly slower)
- `$ProgressPreference = 'SilentlyContinue'` before any `Invoke-WebRequest`
- `foreach` language construct is faster than `ForEach-Object` for in-memory collections
- Rough ordering when it matters: language features > compiled .NET methods > script > cmdlet/pipeline calls
- Measure before optimizing (`Measure-Command`); don't trade away readability for a gain that won't matter at this repo's data sizes

---

## 9. Version Compatibility

Every standalone script must declare the minimum PowerShell version:

```powershell
#Requires -Version 5.1
```

This repo targets both Windows PowerShell 5.1 and PowerShell 7+. Guard 7+-only features:

```powershell
if ($PSVersionTable.PSVersion.Major -ge 7) {
  # PS7+ path
} else {
  # PS5.1 fallback
}
```

---

## 10. CI Reminders

- Lint before committing: `Invoke-ScriptAnalyzer -Path <file> -Settings PSScriptAnalyzerSettings.psd1`
- Run tests when the changed area has coverage: `Invoke-Pester -Path tests/ -Output Minimal`
- CI-enforced (pipeline fails): `PSAvoidGlobalAliases`, `PSAvoidUsingConvertToSecureStringWithPlainText`

---

Source: [PowerShell Practice and Style](https://github.com/PoshCode/PowerShellPracticeAndStyle)
