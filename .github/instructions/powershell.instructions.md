---
description: "PowerShell scripting standards for Windows setup and optimization"
applyTo: "**/*.ps1"
---

# PowerShell Scripting Guidelines

Instructions for authoring PowerShell (5.1+, recommended 7+) scripts for Windows setup, optimization, and automation.

## General Instructions
- Target PowerShell **7+** when possible; maintain compatibility with 5.1 if required—note differences.
- Use OTBS brace style, **2-space indentation** (per `.vscode/settings.json`).
- Prefer built-in cmdlets; avoid external dependencies.
- Centralize shared logic in `Scripts/Common.ps1` and reuse its helpers instead of duplicating code.

## Parameters & Cmdlet Design
- Use `[CmdletBinding()]` and `param()` with proper typing and validation attributes.
- Support `-WhatIf`/`-Confirm` for destructive actions.
- Default to non-admin; detect and request elevation via shared helper.
- Return objects, not formatted text; let callers format via `Format-Table/List`.

## Error Handling
- Set `$ErrorActionPreference = 'Stop'` in scripts; use `try { ... } catch [ExceptionType] { ... } finally { ... }`.
- Be specific in catches; avoid bare `catch`.
- Provide clear error messages with actionable remediation.

## Style & Naming
- Follow verb-noun naming; use approved verbs (`Get`, `Set`, `New`, `Test`, `Invoke`).
- Use PascalCase for functions/parameters, camelCase for locals, ALL_CAPS for constants.
- Avoid aliases in scripts; use full cmdlet names.

## Performance
- Minimize pipeline overhead in hot paths; prefer bulk operations.
- Avoid unnecessary subshells and `Invoke-Expression`.
- For file IO, prefer `Get-Content -Raw` and `Set-Content -NoNewline` when appropriate.

## Filesystem & Paths
- Use `Join-Path` and `Resolve-Path`; avoid string concatenation for paths.
- Be explicit about encodings: `-Encoding UTF8` (without BOM for configs unless required).
- Do not assume current directory; base on `$PSScriptRoot`.

## Registry & System Tweaks
- Guard registry edits with backups or confirmations.
- Use `Test-Path` before `New-Item`/`Set-ItemProperty`.
- Keep system tweaks idempotent; check current state before changing.

## Examples

### Good Example – Idempotent registry set
```powershell
[CmdletBinding(SupportsShouldProcess)]
param(
  [Parameter(Mandatory)]
  [string]$KeyPath,
  [Parameter(Mandatory)]
  [string]$Name,
  [Parameter(Mandatory)]
  [string]$Value
)

$ErrorActionPreference = 'Stop'
Import-Module "$PSScriptRoot/Common.ps1" -Force

if (-not (Test-Path $KeyPath)) {
  if ($PSCmdlet.ShouldProcess($KeyPath, 'Create registry key')) {
    New-Item -Path $KeyPath -Force | Out-Null
  }
}

$current = Get-ItemProperty -Path $KeyPath -Name $Name -ErrorAction SilentlyContinue
if ($current.$Name -ne $Value -and $PSCmdlet.ShouldProcess($KeyPath, "Set $Name")) {
  Set-ItemProperty -Path $KeyPath -Name $Name -Value $Value -Force
}
```

### Bad Example – Aliases, no idempotency
```powershell
param($k,$n,$v)
ls HKLM:\$k | ft
set-itemproperty HKLM:\$k $n $v
```

## Validation
- Lint: `pwsh -NoProfile -Command "Invoke-ScriptAnalyzer -Path ."`
- Format: `pwsh -NoProfile -Command "Invoke-Formatter -Path <file>"`
- Test: Run with `-WhatIf` first; confirm exit codes in non-admin/admin shells as needed.

## Maintenance
- Update when `Common.ps1` changes; align function signatures.
- Re-test scripts after Windows/driver updates that touch edited areas.
- Keep examples current with target PowerShell version.
