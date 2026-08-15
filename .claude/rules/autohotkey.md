# AutoHotkey v2 Rules

Applies to all AutoHotkey files: `ahk/**/*.ahk`, `Lib/**/*.ahk`, and `*.ahk` v2 scripts elsewhere.

---

## Goals

- Target AHK v2.x exclusively (no v1 syntax)
- Pure AHK preferred; avoid external binaries
- Windows-only, portable: relative paths from `A_ScriptDir`
- Centralize reuse in `Lib/`; no copy-paste of shared logic

---

## Standards

**Directives**: `#Requires AutoHotkey v2.0`, `#SingleInstance Force`, `SendMode "Input"`, `SetWorkingDir A_ScriptDir`

**Naming**: Functions `PascalCase()`, locals and globals `camelCase`, constants `UPPER_SNAKE_CASE`. Declare `global` explicitly inside any function that reads or mutates a global.

**Style**: CRLF, UTF-8 without BOM, 4-space indent (per `.editorconfig`), OTBS braces

**Structure**: Short hotkey handlers, delegate to functions. Guard clauses + early returns. No magic numbers.

**Performance**: `WinWait*`/`ProcessWait` over `Sleep` loops. `SetTimer()` over tight loops. Cooldowns on `PixelSearch`/`ImageSearch`.

**Errors**: `try`/`catch Error as e` around risky ops, report `e.Message` with context. `MsgBox()`/`TrayTip()` for user-facing errors. `OnError()` for a script-level fallback handler.

**Data structures**: `Map()` for key/value data — v2 object literals (`{}`) are not associative arrays and don't support arbitrary string keys the way `Map()` does.

**Callbacks**: fat-arrow for short `SetTimer`/`OnMessage`/GUI event handlers: `SetTimer(() => Check(), -500)`.

**Includes**: `#Include` paths relative to `A_ScriptDir`; never absolute or drive-lettered.

```ahk
#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

#Include A_ScriptDir "\..\Lib\WindowManager.ahk"

ToggleFullscreen() {
    target := "Game Title"
    if !WaitForWindow(target, 4) {
        MsgBox("Failed to find window: " target, "Error", "Iconx")
        return
    }
    ToggleFakeFullscreenMultiMonitor(target)
}
F11::ToggleFullscreen()
```

---

## Testing and CI

CI is `.github/workflows/ahk-lint-format-compile.yml`; these rules exist to pass it.

- Test files: named `test_*.ahk` or `*_Test.ahk`, placed under `tests/`, `ahk/`, or `Lib/`.
- Test files must declare `#Requires AutoHotkey v2.0` — CI skips test discovery for files without it.
- Tests fail the run on a non-zero exit code or a 30s timeout; call `ExitApp(1)` on assertion failure.
- Testable functions take optional mock parameters for their side effects, e.g. `RequireAdmin(mockIsAdmin := "", mockRun := "", mockMsgBox := "", mockExitApp := "")` in `Lib/AHK_Common.ahk` — follow this pattern for new `Lib/` helpers that call `Run`, `MsgBox`, or `ExitApp`.
- CI classifies a file as v2 if it has the `#Requires AutoHotkey v2` directive **or** lives under `Lib/`, `ahk/`, or `Other/**/v2/`. New v2 scripts outside those paths must carry the directive explicitly.
- CI fails the build on mixed indentation (tabs + spaces in the same file), trailing whitespace, or mixed line endings — not on indent width, so match the file you're editing.

---

## Limitations

- No v1 command syntax (`MsgBox, text` -> `MsgBox("text")`)
- No legacy `%var%` expansions
- No `Sleep` as primary wait mechanism
- No tight loops without delay
- No hardcoded drive letters
- No admin unless `RequireAdmin()` from `AHK_Common.ahk`
