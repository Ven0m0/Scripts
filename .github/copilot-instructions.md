# GitHub Copilot Instructions

Use `AGENTS.md` as the canonical repository guide. This file is the short entry point for Copilot.

## Startup checklist

- This is a Windows automation repo. Prefer AutoHotkey v2 work in `ahk/` and `Lib/v2/`; treat `Other/` as legacy unless the task explicitly targets it.
- Reuse `Lib/v2/AHK_Common.ahk`, `Lib/v2/WindowManager.ahk`, and `Lib/v2/AutoStartHelper.ahk` before adding new logic.
- Keep startup guidance here short. Put durable repo-wide rules in `AGENTS.md`, path rules in `.github/instructions/`, and reusable workflows in `.github/skills/`.
- For agent guidance updates, follow `.github/instructions/agent-docs.instructions.md`.
- For validation, use the repo workflows and `.github/skills/validate/SKILL.md`.
