# AGENTS.md

> Canonical AI guidance for this repository. `CLAUDE.md` must remain a symlink to this file.

## Repository snapshot

- **Project:** Windows gaming, emulation, and utility automation scripts
- **Primary language:** AutoHotkey v2 (`ahk/`, `Lib/v2/`)
- **Legacy surface:** AutoHotkey v1 scripts and helper assets in `Other/`
- **Platform:** Windows 10/11 for runtime and meaningful validation
- **Canonical user docs:** `README.md`, `CONTRIBUTING.md`, directory READMEs

## How to use this guide

- Treat this file as the detailed, shared source of truth for AI assistants.
- Keep `.github/copilot-instructions.md` shorter and reference this file instead of duplicating large sections.
- Keep guidance repo-specific; remove version counts, file counts, and other details that drift quickly.

## Repository map

```text
ahk/                    Primary AutoHotkey v2 scripts
Lib/v2/                 Shared v2 helpers (`AHK_Common`, `WindowManager`, `AutoStartHelper`)
Other/                  Legacy v1 scripts plus PowerShell/CMD utilities and specialized tools
.github/instructions/   Language/domain-specific guidance for Copilot
.github/workflows/      CI definitions; `ahk-lint-format-compile.yml` is the main AHK validation workflow
```

## Core rules

1. **Prefer v2 for new work.** Add new automation scripts under `ahk/` unless a legacy workflow in `Other/` requires v1 compatibility.
2. **Reuse shared helpers before adding new logic.** Check `Lib/v2/` first for initialization, fullscreen, window, and auto-start behavior.
3. **Be careful with shared libraries.** Changes in `Lib/v2/` can affect many scripts; inspect consumers before editing and test representative dependents.
4. **Respect Windows-oriented formatting rules.**
   - `.ahk`, `.ps1`, `.cmd`, `.bat`: CRLF, UTF-8, 4 spaces
   - `.md`, `.json`, `.yml`, `.yaml`: LF
   - Follow `.editorconfig` and `.gitattributes` when they differ from editor defaults.
5. **Avoid hardcoded user-specific paths.** Prefer `A_ScriptDir`, `A_MyDocuments`, `%AppData%`, and environment-aware logic.
6. **Preserve low-latency behavior.** Gaming and automation scripts should keep `InitScript()` or equivalent performance settings unless there is a documented reason not to.
7. **Keep documentation synchronized by design.** Put durable repo-wide rules here; keep shorter tool-entry docs concise and linked back here.

## AutoHotkey guidance

### v2 scripts (`ahk/` and some `Other/*.ahk`)

- Start with `#Requires AutoHotkey v2.0`.
- Reuse `Lib/v2/AHK_Common.ahk` and call `InitScript(...)` when appropriate.
- Use v2 function syntax consistently.
- Prefer existing helpers such as `ToggleFakeFullscreenMultiMonitor()`, `WaitForWindow()`, and `AutoStartFullscreen()` instead of copy-pasting window/process logic.

### Legacy v1 areas (`Other/`)

- Treat v1 scripts as maintenance-oriented unless the task explicitly requires legacy behavior.
- Preserve local helper/binary assumptions in those folders, for example:
  - `Other/Citra_per_game_config/` depends on `tf.ahk`
  - `Other/Downloader/` expects companion binaries such as `yt-dlp.exe`, `spotdl.exe`, and `ffmpeg.exe`
- Do not migrate or rewrite legacy scripts opportunistically during unrelated tasks.

## Change checklists

### When editing `Lib/v2/`

- Find dependents first (for example, grep for `#Include` references).
- Keep public helper names and calling conventions stable unless the task requires a coordinated refactor.
- Test multiple consuming scripts on Windows before considering the change complete.

### When editing docs or AI guidance

- Update `AGENTS.md` first when changing repo-wide rules.
- Keep `.github/copilot-instructions.md` as a compact operating summary.
- Do not replace `CLAUDE.md`; it should continue to resolve to `AGENTS.md`.

## Validation notes

- The authoritative AHK CI workflow is `.github/workflows/ahk-lint-format-compile.yml`.
- That workflow performs version detection, syntax compilation, and formatting checks on Windows.
- If you need to reproduce CI locally, prefer matching the workflow definitions over older duplicated doc snippets.

## Useful references

- `README.md` - project overview and user-facing setup
- `CONTRIBUTING.md` - contributor workflow expectations
- `ahk/README.md`, `Lib/README.md`, `Other/*/README.md` - area-specific behavior and dependencies
- `.github/instructions/autohotkey.instructions.md` - file-type guidance for Copilot
