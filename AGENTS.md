# AGENTS.md

> Canonical AI guidance for this repository. `CLAUDE.md` must remain a symlink to this file.

## Repository snapshot

- **Project:** Windows gaming and utility automation scripts
- **Primary language:** AutoHotkey v2, exclusively (`ahk/`, `Lib/`)
- **Platform:** Windows 10/11 for runtime and meaningful validation
- **Canonical user docs:** `README.md`, `EXAMPLES.md`, directory READMEs

## How to use this guide

- Treat this file as the detailed, shared source of truth for AI assistants.
- Keep `.github/copilot-instructions.md` shorter and reference this file instead of duplicating large sections.
- Keep guidance repo-specific; remove version counts, file counts, and other details that drift quickly.

## Repository map

```text
ahk/                    AutoHotkey v2 scripts
Lib/                    Shared v2 helpers (`AHK_Common`, `WindowManager`)
tests/                  Standalone test scripts
.claude/rules/          Language rulesets (AutoHotkey, PowerShell) auto-loaded as project context
.kilo/                  Kilo agent config (`kilo.json`); instructions resolve back to `AGENTS.md`
.github/workflows/      CI definitions; `ahk-lint-format-compile.yml` is the main AHK validation workflow
```

## Core rules

1. **AHK v2 only.** Every `.ahk` file in this repo targets v2; no v1 command syntax anywhere.
2. **Reuse shared helpers before adding new logic.** Check `Lib/` first for initialization, fullscreen, and window behavior.
3. **Be careful with shared libraries.** Changes in `Lib/` can affect many scripts; inspect consumers before editing and test representative dependents.
4. **Respect Windows-oriented formatting rules.**
   - `.ahk`, `.ps1`, `.cmd`, `.bat`: CRLF, UTF-8, 4 spaces
   - `.md`, `.json`, `.yml`, `.yaml`: LF
   - Follow `.editorconfig` and `.gitattributes` when they differ from editor defaults.
5. **Avoid hardcoded user-specific paths.** Prefer `A_ScriptDir`, `A_MyDocuments`, `%AppData%`, and environment-aware logic.
6. **Preserve low-latency behavior.** Gaming and automation scripts keep `InitScript()` or equivalent performance settings unless the task documents an explicit exception.
7. **Keep documentation synchronized by design.** Put durable repo-wide rules here; keep shorter tool-entry docs concise and linked back here.

## AutoHotkey guidance

- Start every script with `#Requires AutoHotkey v2.0`.
- Reuse `Lib/AHK_Common.ahk` and call `InitScript(...)` in entry scripts that need shared startup behavior.
- Use v2 function syntax consistently.
- Prefer existing helpers such as `ToggleFakeFullscreen()`, `ToggleFakeFullscreenMultiMonitor()`, and `WaitForWindow()` instead of copy-pasting window and process logic.

## Change checklists

### When editing `Lib/`

- Find dependents first (for example, grep for `#Include` references).
- Keep public helper names and calling conventions stable unless the task requires a coordinated refactor.
- Test multiple consuming scripts on Windows before considering the change complete.

### When editing docs or AI guidance

- Update `AGENTS.md` first when changing repo-wide rules.
- Keep `.github/copilot-instructions.md` as a compact operating summary.
- Keep `CLAUDE.md` resolving to `AGENTS.md`.

## Validation notes

- The authoritative AHK CI workflow is `.github/workflows/ahk-lint-format-compile.yml`.
- That workflow performs syntax compilation and formatting checks on Windows.
- If you need to reproduce CI locally, prefer matching the workflow definitions over older duplicated doc snippets.

## Release notes

- Pushing a tag triggers `build.yml` and `build-cached.yml` to create release artifacts.
- Treat tagged builds as the release path for compiled `.exe` outputs.

## Useful references

- `README.md` - project overview and user-facing setup
- `EXAMPLES.md` - usage examples
- `ahk/README.md`, `Lib/README.md` - area-specific behavior and dependencies
- `.claude/rules/autohotkey.md` - AutoHotkey v2 rules and conventions
