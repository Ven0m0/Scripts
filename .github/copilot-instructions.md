# GitHub Copilot Instructions

Use `AGENTS.md` as the canonical repository guide. This file is the short entry point for Copilot.

## Startup checklist

- This is a Windows automation repo. All AutoHotkey work is v2, in `ahk/` and `Lib/`.
- Reuse `Lib/AHK_Common.ahk` and `Lib/WindowManager.ahk` before adding new logic.
- Keep startup guidance here short. Put durable repo-wide rules in `AGENTS.md`, path rules in `.github/instructions/`, and reusable workflows in `.github/skills/`.
- For agent guidance updates, follow `.github/instructions/agent-docs.instructions.md`.
- For validation, use the repo workflows and `.github/skills/validate/SKILL.md`.
