---
description: "AutoHotkey v2 scripting standards for Windows automation and gaming tools"
applyTo: "**/*.ahk"
---

# AutoHotkey v2 Scripting Guidelines

Repository-wide instructions for writing **performant, maintainable AutoHotkey v2** scripts across window management, emulator automation, and gaming utilities.

## General
- Target **AutoHotkey v2.x** syntax exclusively (no v1 command syntax).
- Prefer **pure AHK**; avoid external binaries unless absolutely required.
- Windows-only + portable: use relative paths from `A_ScriptDir`, never hardcode drive letters.
- Keep reuse centralized in `Lib/` (e.g., `AHK_Common.ahk`, `WindowManager.ahk`, `AutoStartHelper.ahk`). Do not copy/paste shared logic.
- Require admin only when needed; reuse `RequireAdmin()` from `AHK_Common.ahk`.
- Fail fast for user-facing problems (missing exe/window/config) with `MsgBox()`/`TrayTip()` and include actionable context.

## File/Encoding/Style
- Line endings: **CRLF** (Windows scripts).
- Encoding: **UTF-8 with BOM** (keeps compatibility with older tooling and v1-friendly editors).
- Indent: **2 spaces**; OTBS brace style (`Func() {` on the same line).
- Names:
  - Functions: `PascalCase()`
  - Locals: `camelCase`
  - Constants/hotkey labels: `UPPER_SNAKE_CASE`
  - Globals: prefix with `g_` and keep the surface area small.

## v2 Correctness (Critical)
- Use v2 directives and functions:
  - `#SingleInstance Force`
  - `#Requires AutoHotkey v2.0`
  - `SendMode "Input"`
  - `SetWorkingDir A_ScriptDir`
- Use v2 function-call syntax everywhere:
  - `MsgBox("text")` (not `MsgBox, text`)
  - `WinWait("ahk_exe foo.exe",, 4)`
  - `WinSetStyle("-0xC40000", "ahk_id " hwnd)`
- Prefer `Win*` functions with **HWND** when available.
- Avoid legacy `%var%` expansions; use expression syntax (`x := y`, `"text " var`).

## Structure
- Keep hotkey/timer handlers short; delegate real work to functions.
- Avoid deep nesting: guard clauses + early returns.
- Avoid magic numbers: extract to constants at top-level.
- Use `try`/`catch as e` only around risky operations; report `e.Message` and relevant context.

## Performance
- Minimize `Sleep`; prefer `WinWait*` / state checks with bounded timeouts.
- Never spin in tight loops without a delay; use `SetTimer()` or backoff (`Sleep 50`) when polling is unavoidable.
- Avoid repeated `PixelSearch`/`ImageSearch` in hot paths; gate with cooldowns or run on timer.
- Batch filesystem + registry operations; prefer AHK built-ins over spawning PowerShell/CMD.

## Window & Display Handling
- Reuse `Lib\WindowManager.ahk` helpers (`ToggleFakeFullscreen*`, `SetWindowBorderless`, `WaitForWindow`, `WaitForProcess`).
- Guard window operations with explicit timeouts and user feedback.
- For multi-monitor behavior, prefer the provided multi-monitor helpers; do not reinvent monitor enumeration.

## Hotkeys
- Document hotkeys near the top in a small table.
- Use context (`#HotIf WinActive(...)`) to avoid global conflicts.
- Provide an escape hatch for macros/loops (e.g., `Esc` or `^!q`) that reliably stops looped input.

## Logging / Diagnostics
- For intermittent issues, log to:
  - `logPath := A_Temp "\\" A_ScriptName ".log"`
- Include:
  - timestamp (`A_Now`), script version, target exe/title, and the last error.

## Examples

### Good – v2 fullscreen toggle using shared library
```ahk
#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

#Include A_ScriptDir "\..\Lib\WindowManager.ahk"

ToggleFullscreen() {
  target := "Game Title"
  if !WaitForWindow(target, 4000) {
    MsgBox("Failed to find window: " target, "Error", "Iconx")
    return
  }
  ToggleFakeFullscreenMultiMonitor(target)
}

F11::ToggleFullscreen()
```

### Bad – v1 syntax and unbounded waits
```ahk
; v1 command syntax + no timeout
F11::
WinWaitActive, Game Title
WinSet, Style, -0xC40000, Game Title
return
```

## Validation
- Manual: run script with target app; test hotkeys and escape hatch.
- Lint: IDE + basic sanity checks (no unresolved `#Include`).
- Functional: verify multi-monitor behavior and admin-required paths when applicable.

## Maintenance
- When `Lib/` helper APIs change, propagate signature changes across dependent scripts.
- Re-test hotkeys after Windows/driver updates.
- Keep the hotkey docs in sync with script behavior.
