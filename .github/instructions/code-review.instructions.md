---
applyTo: "**"
excludeAgent: "coding-agent"
---

# Code Review Instructions

Review changes in **English** and focus on the highest-risk issues first.

## Priority order

1. **Security and safety**
   - No secrets, unsafe shell usage, or command injection paths
   - No hardcoded user-specific or machine-specific paths when a portable alternative exists
2. **Correctness**
   - Automation still targets the right window, process, or config surface
   - Legacy `Other/` behavior is preserved unless the change explicitly updates that workflow
3. **Shared library impact**
   - Changes in `Lib/v2/` keep helper names and calling conventions stable
   - Reused helpers are preferred over copy-pasted logic
4. **Validation coverage**
   - The author ran the narrowest relevant checks for the files they touched
   - Workflow, instruction, and skill changes reference real commands and real paths

## Review focus by area

### AutoHotkey

- Prefer AutoHotkey v2 for new work
- Verify `#Requires AutoHotkey v2.0` and existing setup helpers are kept where expected
- Watch for unnecessary `Sleep` loops, tight polling, or latency regressions
- Flag changes that should reuse `Lib/v2/AHK_Common.ahk`, `WindowManager.ahk`, or `AutoStartHelper.ahk`

### Legacy `Other/` scripts

- Treat v1 scripts as maintenance work unless the task clearly calls for legacy updates
- Preserve local companion binary expectations such as downloader tools and Citra helpers
- Avoid opportunistic migrations during unrelated fixes

### PowerShell and CMD

- Quote paths with spaces
- Keep fail-fast behavior and explicit error handling
- Reject `Invoke-Expression` with untrusted input
- Check batch files for `setlocal`, delayed expansion rules, and `errorlevel` handling

### Copilot guidance and workflows

- `AGENTS.md` remains the canonical repo-wide guide
- `.github/copilot-instructions.md` stays short and points back to the canonical guidance
- `.github/instructions/` stays narrow and path-specific
- `.github/skills/` stays reusable and tied to real repo workflows
- Guidance validation uses `ctxlint` and `agnix`
- Workflow changes use the repo's actual runners, tools, and commands

## Review comment format

- Be specific about the affected file and why the issue matters
- Use GitHub suggestion blocks whenever proposing an exact code or text change
- Do not request speculative refactors outside the task scope

## Repo-specific reminders

- `.ahk`, `.ps1`, `.cmd`, `.bat` use CRLF
- `.md`, `.json`, `.yml`, `.yaml` use LF
- `CLAUDE.md` should continue to resolve to `AGENTS.md`
