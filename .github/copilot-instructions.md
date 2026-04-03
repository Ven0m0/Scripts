# GitHub Copilot Instructions

Use `AGENTS.md` as the canonical repository guide. This file is the short entry point for Copilot.

## Project context

- Windows-only automation toolkit for gaming, emulation, media, and desktop workflows
- Primary development targets AutoHotkey v2 in `ahk/` with shared helpers in `Lib/v2/`
- `Other/` contains legacy v1 scripts plus PowerShell/CMD utilities and specialized tools

## Working rules

- Prefer AutoHotkey v2 for new work unless a legacy `Other/` workflow requires v1 compatibility.
- Check `Lib/v2/AHK_Common.ahk`, `Lib/v2/WindowManager.ahk`, and `Lib/v2/AutoStartHelper.ahk` before adding new logic.
- Preserve low-latency behavior for automation scripts; keep `InitScript()` or equivalent setup unless the task requires otherwise.
- Avoid hardcoded machine-specific paths; use script-relative or environment-aware paths.
- Follow repo formatting rules exactly:
  - `.ahk`, `.ps1`, `.cmd`, `.bat` -> CRLF, UTF-8, 4 spaces
  - `.md`, `.json`, `.yml`, `.yaml` -> LF
- Be cautious with shared-library edits in `Lib/v2/`; they can affect multiple scripts.

## Validation and references

- CI source of truth: `.github/workflows/ahk-lint-format-compile.yml`
- Additional file-specific guidance: `.github/instructions/`
- Detailed repo guidance: `AGENTS.md` (`CLAUDE.md` should resolve to the same content)
