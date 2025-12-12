---
description: "Batch/CMD scripting standards for Windows utilities"
applyTo: "**/*.cmd, **/*.bat"
---

# CMD/Batch Scripting Guidelines

Instructions for writing minimal, reliable CMD/Batch scripts for Windows utilities and bootstrap tasks.

## General Instructions
- Target `cmd.exe`; assume Windows 10+.
- Keep scripts **self-contained**; avoid external tools unless already standard on Windows.
- Use CRLF line endings; ASCII/UTF-8 without BOM.

## Code Standards
- Start with `@echo off` and `setlocal enabledelayedexpansion`.
- Quote all paths: `"%%~dp0"` for script dir; never parse `dir` output—use `for`.
- Use `if defined`/`if not defined` for presence checks; prefer `if /i` for case-insensitive compares.
- Avoid `%random%` for security decisions.
- Prefer `for %%V in (...) do` for iteration; avoid unbounded `goto` spaghetti—structure with labels and early exits.

## Environment & Safety
- Do not mutate global environment; end with `endlocal`.
- Validate prerequisites (admin, files) before actions.
- Use `%ERRORLEVEL%` checks after critical commands; `exit /b 1` on failure.

## I/O & Logging
- Use `>nul 2>&1` to silence noisy commands; log to `%TEMP%\script.log` when debugging.
- Avoid `findstr` regex complexity; keep patterns simple and quoted.

## Examples

### Good Example – Safe path handling
```bat
@echo off
setlocal enabledelayedexpansion
set "ROOT=%~dp0"
if not exist "%ROOT%data.txt" (
  echo Missing data.txt>&2
  exit /b 1
)
for /f "usebackq delims=" %%L in ("%ROOT%data.txt") do (
  echo %%L
)
endlocal
```

### Bad Example – Unquoted paths, env pollution
```bat
echo on
set PATH=%CD%\tools;%PATH%
type data.txt
```

## Validation
- Run in clean `cmd.exe` session.
- Test with spaces in paths.
- Confirm correct exit codes for success/failure.

## Maintenance
- Keep logic minimal; prefer moving complex flows to PowerShell.
- Re-test after Windows updates that may affect built-ins.
