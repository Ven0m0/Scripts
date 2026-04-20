---
name: copilot-init
description: Initialize or refresh Copilot guidance for this Windows automation repo. Use when updating bootstrap files, repo-specific instructions, and reusable skills.
allowed-tools: 'Read, Write, Edit, Glob, Grep, Bash'
---

# Copilot init

Create or refresh Copilot bootstrap assets for this repository. Derive all guidance from the repository itself and from files already present in the repo.

## Goal

Produce a minimal, high-signal set of bootstrap and validation assets:

- `.github/workflows/copilot-setup-steps.yml`
- `.github/instructions/*.instructions.md`
- `.github/skills/*/SKILL.md`
- short `.github/copilot-instructions.md` updates when startup guidance drifts

Keep startup guidance short, keep detailed repo-wide guidance in `AGENTS.md`, and avoid duplicating large rule blocks across files.

## Workflow

1. Audit the repo before editing.
   - Primary language: AutoHotkey v2 in `ahk/` and `Lib/v2/`
   - Legacy surface: AutoHotkey v1 plus PowerShell and CMD utilities in `Other/`
   - Canonical repo-wide guide: `AGENTS.md`
   - Existing CI anchors: `.github/workflows/ahk-lint-format-compile.yml` and `.github/workflows/powershell.yml`
2. Keep the guidance split clean.
   - `.github/copilot-instructions.md`: short startup summary only
   - `AGENTS.md`: canonical repo-wide rules
   - `.github/instructions/`: narrow file-type or workflow rules
   - `.github/skills/`: reusable task playbooks
3. Create or update `.github/workflows/copilot-setup-steps.yml`.
   - Use an Ubuntu job named `copilot-setup-steps` so Copilot bootstrap tooling can run in the default agent environment
   - Install the guidance tooling the agent can use directly, and point runtime validation back to the existing Windows workflows
   - Keep triggers limited to `workflow_dispatch` plus changes to the workflow file itself
4. Update instructions only where the repo needs them.
   - Keep AutoHotkey, PowerShell, CMD, review, and agent-doc guidance aligned with the repo
   - Remove generic examples or nonexistent paths when they drift
5. Update reusable skills only when they map to real repo workflows.
   - `validate` should cover AutoHotkey, PowerShell, CMD, and agent-guidance validation
   - Call out the exact repo commands for `ctxlint` and `agnix`
6. Validate the result.
   - Verify every referenced path and command exists
   - Run `npx -y @yawlabs/ctxlint --depth 3 --mcp --strict --fix --yes`
   - Run `npx -y agnix --fix-safe .`

## Portability requirements

- Preserve good existing guidance files instead of replacing them wholesale.
- Respect `AGENTS.md` as the canonical guide and keep `CLAUDE.md` resolving to it.
- Prefer the smallest file set that still gives high-signal guidance.

## Guardrails

- Never invent commands, paths, dependencies, or workflows.
- Keep guidance concise, actionable, and repository-specific.
- Update good existing files instead of creating duplicates.
- Do not add validation for languages or tools the repository does not use.

## Deliverables checklist

- `copilot-setup-steps` matches the repo's real setup path
- Instructions reflect the real stack, commands, and hotspots
- Skills reflect recurring repo workflows
- Large rule blocks are not duplicated across files
- All changed files are internally consistent
