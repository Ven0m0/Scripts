---
applyTo:
  - "AGENTS.md"
  - ".github/copilot-instructions.md"
  - ".github/instructions/*.md"
  - ".github/skills/*/SKILL.md"
  - ".github/workflows/copilot-setup-steps.yml"
---

# Agent Guidance Instructions

Keep agent-facing files minimal, repo-specific, and internally consistent.

## Structure

- `AGENTS.md` is the canonical long-form guide
- `.github/copilot-instructions.md` is the short startup summary
- `.github/instructions/` holds narrow path or workflow rules
- `.github/skills/` holds reusable task playbooks
- `.github/workflows/copilot-setup-steps.yml` bootstraps the tooling an agent actually needs

## Content rules

- Describe this repository as a Windows automation toolkit centered on AutoHotkey v2 with legacy content in `Other/`
- Reference only real files, commands, and workflows already present in the repo
- Keep repo-wide rules in `AGENTS.md` instead of duplicating them elsewhere
- Prefer short bullets over long generic templates
- Call out shared hotspots such as `Lib/v2/`, `Other/`, and the existing validation workflows

## Validation

- Run the guidance lint and normalization commands from `.github/skills/validate/SKILL.md`
- Re-read changed files to confirm the commands did not invent paths or workflows
