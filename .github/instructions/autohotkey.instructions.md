---
applyTo: "**/*.ahk"
---

# AutoHotkey v2 Guidelines

<Goals>

- Target AHK v2.x exclusively (no v1 syntax)
- Pure AHK preferred; avoid external binaries
- Windows-only, portable: relative paths from `A_ScriptDir`
- Centralize reuse in `Lib/`; no copy-paste of shared logic

</Goals>

<Standards>

**Directives**: `#Requires AutoHotkey v2.0`, `#SingleInstance Force`, `SendMode "Input"`, `SetWorkingDir A_ScriptDir`

**Naming**: Functions `PascalCase()`, locals `camelCase`, constants `UPPER_SNAKE_CASE`, globals `g_` prefix

**Style**: CRLF, UTF-8 with BOM, 2-space indent, OTBS braces

**Structure**: Short hotkey handlers, delegate to functions. Guard clauses + early returns. No magic numbers.

**Performance**: `WinWait*` over `Sleep`. `SetTimer()` over tight loops. Cooldowns on `PixelSearch`/`ImageSearch`.

**Errors**: `try`/`catch as e` around risky ops, report `e.Message` with context. `MsgBox()`/`TrayTip()` for user-facing errors.

</Standards>

```ahk
#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

#Include A_ScriptDir "\..\Lib\WindowManager.ahk"

ToggleFullscreen(){
  target := "Game Title"
  if !WaitForWindow(target, 4000) {
    MsgBox("Failed to find window: " target, "Error", "Iconx")
    return
  }
  ToggleFakeFullscreenMultiMonitor(target)
}
F11::ToggleFullscreen()
```

<Limitations>

- No v1 command syntax (`MsgBox, text` -> `MsgBox("text")`)
- No legacy `%var%` expansions
- No `Sleep` as primary wait mechanism
- No tight loops without delay
- No hardcoded drive letters
- No admin unless `RequireAdmin()` from `AHK_Common.ahk`

</Limitations>
