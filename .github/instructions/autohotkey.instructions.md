---
description: "AutoHotkey v1.1 scripting standards for Windows automation and gaming tools"
applyTo: "**/*.ahk"
---

# AutoHotkey Scripting Guidelines

Instructions for writing performant, maintainable AutoHotkey v1.1 scripts across window management, emulator automation, and gaming utilities.

## General Instructions
- Target AutoHotkey **v1.1** (not v2).
- Prefer **pure AHK**; avoid external binaries unless absolutely required.
- Keep scripts **portable** and **Windows-only**; assume CRLF line endings.
- Centralize reusable logic in `Lib/` (e.g., `AHK_Common.ahk`, `WindowManager.ahk`, `AutoStartHelper.ahk`). Do not duplicate.
- Require admin only when needed; reuse `RequireAdmin()` from `AHK_Common.ahk`.
- Fail fast with clear `MsgBox`/`TrayTip` for user-facing errors; log context for debugging.

## Code Standards
- Encoding: UTF-8 with BOM (AHK v1-friendly).
- Indent with **two spaces**; OTBS brace style.
- Use **PascalCase** for functions, **CamelCase** for variables, **UPPER_SNAKE_CASE** for constants/hotkeys labels.
- Prefix globals with `g_`; minimize globals—prefer function scope.
- Use `#SingleInstance Force`, `#NoEnv`, `SendMode Input`, `SetWorkingDir %A_ScriptDir%`.
- Timer/hotkey handlers must be short; offload work into functions.
- Avoid magic numbers—extract to `const`.
- Prefer `If (expr)` and `Switch` for clarity; avoid deep nesting via early returns.

## Performance
- Minimize `Sleep`; use event-driven hotkeys and window waits (`WinWait`, `WinWaitActive`).
- Cache window titles/handles when polling; avoid tight loops without `Sleep`.
- Avoid repeated `PixelSearch/ImageSearch` in hot paths; gate with cooldowns.
- Batch registry/file operations; avoid spawning shells—use AHK built-ins.

## Window & Display Handling
- Reuse `WindowManager.ahk` helpers (`ToggleFakeFullscreen`, `SetWindowBorderless`, `WaitForWindow`, `WaitForProcess`).
- Always guard window ops with timeouts; handle multi-monitor via provided helpers.

## Hotkeys
- Document hotkeys in a header table.
- Use context (`#IfWinActive/#If`) to avoid global conflicts.
- Provide an **escape hatch** (`Esc` or `Ctrl+Alt+Q`) for long-running loops/macros.

## Error Handling
- Wrap risky calls with retries and bounded waits.
- Provide user-facing error prompts when automation prerequisites fail (missing window, missing process).
- Log to `%A_Temp%\{ScriptName}.log` when diagnosing intermittent issues.

## File Organization
- Main entry scripts in `AHK/`; shared libs in `Lib/`; game/emulator-specific under their subfolders.
- Keep per-game configs in dedicated folders; do not hardcode absolute paths—use relative paths from `A_ScriptDir`.

## Examples

### Good Example – Window fullscreen toggle
```ahk
#SingleInstance Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

#Include %A_ScriptDir%\..\Lib\WindowManager.ahk

ToggleFullscreen(){
  target := "Game Title"
  if !WaitForWindow(target, 4000)
    return MsgBox, 48, Error, Failed to find %target%.
  ToggleFakeFullscreenMultiMonitor(target)
}

F11::ToggleFullscreen()
```

### Bad Example – Duplicated logic, unsafe waits
```ahk
F11::
WinWaitActive, Game Title
WinSet, Style, -0xC40000, Game Title
return
```

## Validation
- Manual: Run script with target app; test hotkeys and escape hatch.
- Lint: Prefer `ahk-lint` or IDE linting; ensure no unresolved `#Include`.
- Functional: Verify multi-monitor and admin-required paths if applicable.

## Maintenance
- Update when `Lib/` helpers change; propagate signature changes.
- Re-test hotkeys after Windows or driver updates.
- Keep hotkey docs in sync with script behavior.
