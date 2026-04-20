---
name: validate
description: Run the correct validation checks for changed files in this repository (ruff, biome, shellcheck, claudelint, pytest).
allowed-tools: 'Read, Bash, Grep, Glob'
---

# Validate

Run the narrowest checks that cover the files you have changed.

## Triggers

Use this skill when asked to validate, lint, type-check, or test changes before committing.

## Steps

1. Identify which file types were changed (Python, JS/TS, shell, Markdown/agent docs, or mixed).

2. Run only the checks relevant to changed files:

   **Python (`**/\*.py`)\*\*

   ```bash
   uv run ruff format --check <paths>
   uv run ruff check <paths>
   uv run pytest <test-target>
   ```

   **JS / TS (`**/_.ts`, `\*\*/_.js`, etc.)\*\*

   ```bash
   bunx @biomejs/biome check <paths>
   bun run tsc --noEmit
   ```

   **Shell (`**/\*.sh`)\*\*

   ```bash
   shellcheck <paths>
   ```

   **Agent / skill docs (`claude/agents/**`, `claude/skills/**`, `.github/skills/**`)\*\*

   ```bash
   bun run lint:claude
   ```

3. Fix reported issues in the changed files only. Do not touch unrelated files.

4. Re-run the affected check to confirm it passes before reporting success.

## Invariants

- Never remove or skip a check to make it pass.
- Do not modify test files to suppress failures unless the test itself is wrong.
- Report any pre-existing failures that are unrelated to your changes rather than silently fixing them.
