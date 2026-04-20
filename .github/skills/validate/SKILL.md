---
name: validate
description: Run the narrowest repo-specific validation for AutoHotkey, PowerShell, CMD, workflows, and agent guidance changes. Use when checking changes before reporting completion.
allowed-tools: 'Read, Bash, Grep, Glob'
---

# Validate

Run the narrowest checks that cover the files you have changed.

## Steps

1. Identify which file types changed.
2. Run only the checks that match those files.

### Agent guidance, Copilot assets, and related workflows

For `AGENTS.md`, `.github/copilot-instructions.md`, `.github/instructions/**`, `.github/skills/**`, and `.github/workflows/copilot-setup-steps.yml`:

```bash
npx -y @yawlabs/ctxlint --depth 3 --mcp --strict --fix --yes
npx -y agnix --fix-safe .
```

### AutoHotkey

- The source of truth is `.github/workflows/ahk-lint-format-compile.yml`
- If you are on Windows and can mirror that workflow safely, do so
- If you are on a non-Windows agent, do not invent replacement tooling; inspect the changed scripts carefully and rely on the workflow for compile validation

### PowerShell

```bash
pwsh -NoLogo -NoProfile -Command "Invoke-ScriptAnalyzer -Path '<path-to-file>'"
```

### CMD or Batch

- No dedicated repo linter exists today
- Re-read the file and verify quoting, `setlocal`, delayed expansion, and `errorlevel` checks manually

### Workflow and YAML changes

- Re-read every referenced path, runner, action, and command
- Keep validation aligned with the repo's real toolchain and existing workflows

3. Fix issues only in the files you changed.
4. Re-run the affected checks before reporting success.

## Invariants

- Never remove or skip a check to make it pass.
- Do not invent tests or linters that the repo does not use.
- Report pre-existing failures that are unrelated to your changes instead of silently fixing them.
