# Contributing to Scripts

Thank you for considering contributing to this Windows automation toolkit! This guide will help you get started.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Environment](#development-environment)
- [Coding Standards](#coding-standards)
- [Submitting Changes](#submitting-changes)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)

## Code of Conduct

This project follows a simple code of conduct: be respectful, constructive, and collaborative. We welcome contributions from developers of all skill levels.

## Getting Started

### Prerequisites

- **AutoHotkey v2.0.19+** - [Download](https://www.autohotkey.com/)
- **AutoHotkey v1.1.37.02+** - For legacy scripts ([Download UIA version](https://www.autohotkey.com/download/))
- **Windows 10/11** - Required for testing
- **Git** - For version control

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/Scripts.git
   cd Scripts
   ```
3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/Ven0m0/Scripts.git
   ```

## Development Environment

### Recommended Tools

- **VS Code** with AutoHotkey extensions
- **Git Bash** or **PowerShell 7+**
- **AutoHotkey Language Support** extension for VS Code

### Project Structure

```
Scripts/
├── ahk/             # AutoHotkey v2 scripts
├── Lib/             # Shared libraries (v1 and v2)
├── Other/           # Specialized utilities
├── .github/         # CI/CD workflows and instructions
└── docs/            # Additional documentation
```

See [README.md](README.md) for detailed structure information.

## Coding Standards

### AutoHotkey v2 Scripts

All new scripts should target **AutoHotkey v2.0** unless they require v1-specific features.

#### Required Directives

```autohotkey
#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir
```

#### Naming Conventions

- **Functions**: `PascalCase()` - e.g., `ToggleFullscreen()`
- **Variables**: `camelCase` - e.g., `windowTitle`
- **Constants**: `UPPER_SNAKE_CASE` - e.g., `DEFAULT_TIMEOUT`
- **Globals**: Prefix with `g_` - e.g., `g_ScriptPID`

#### Code Style

- **Indentation**: 2 spaces (not tabs)
- **Line Endings**: CRLF (Windows)
- **Encoding**: UTF-8 with BOM
- **Brace Style**: OTBS (One True Brace Style)
  ```autohotkey
  FunctionName() {
    ; code here
  }
  ```

#### Documentation

Add header comments to all scripts:

```autohotkey
; =============================================================================
; Script Name: MyScript.ahk
; Description: Brief description of what the script does
; Author: Your Name
; Version: 1.0.0
; Last Updated: YYYY-MM-DD
; 
; Requirements:
;   - AutoHotkey v2.0+
;   - Admin privileges (if needed)
; 
; Usage:
;   Brief usage instructions
; =============================================================================

#Requires AutoHotkey v2.0
```

### AutoHotkey v1 Scripts

Only modify v1 scripts when fixing critical bugs. For new features, migrate to v2.

#### Performance Directives

Always include these at the top:

```autohotkey
#SingleInstance Force
#NoEnv
ListLines Off
SetBatchLines -1
SetKeyDelay -1, -1
SetMouseDelay -1
SetDefaultMouseSpeed 0
SetWinDelay -1
SetControlDelay -1
SendMode Input
```

### PowerShell Scripts

- Target **PowerShell 7+** when possible
- Use **2-space indentation**
- Include proper parameter validation
- Add comment-based help

```powershell
<#
.SYNOPSIS
  Brief description
.DESCRIPTION
  Detailed description
.PARAMETER ParameterName
  Parameter description
.EXAMPLE
  PS> .\script.ps1
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [string]$ParameterName
)
```

### Batch/CMD Scripts

- Keep scripts minimal and self-contained
- Use `@echo off` and `setlocal`
- Quote all paths
- Check for admin privileges when needed

## Submitting Changes

### Branch Naming

Use descriptive branch names:

- `feature/add-xyz` - New features
- `fix/bug-description` - Bug fixes
- `docs/update-readme` - Documentation updates
- `refactor/improve-xyz` - Code refactoring

### Commit Messages

Follow the Conventional Commits format:

```
<type>: <brief description>

<optional detailed explanation>

<optional footer>
```

**Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code formatting (no logic changes)
- `refactor:` - Code restructuring (no behavior change)
- `perf:` - Performance improvements
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

**Examples:**

```
feat: Add multi-monitor support to Fullscreen.ahk

Implemented automatic monitor detection and positioning
for borderless fullscreen mode.

Closes #123
```

```
fix: Resolve window positioning bug on secondary monitor

Windows were incorrectly positioned when using secondary
monitor as primary display.
```

### Pull Request Process

1. **Update your fork:**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Create a feature branch:**
   ```bash
   git checkout -b feature/my-feature
   ```

3. **Make your changes** following coding standards

4. **Test your changes** thoroughly

5. **Commit with descriptive messages**

6. **Push to your fork:**
   ```bash
   git push origin feature/my-feature
   ```

7. **Open a Pull Request** on GitHub with:
   - Clear description of changes
   - Reference to any related issues
   - Screenshots for UI changes
   - Test results

### Pull Request Checklist

- [ ] Code follows the style guidelines
- [ ] Comments added for complex logic
- [ ] Documentation updated (README, CLAUDE.md, etc.)
- [ ] No trailing whitespace
- [ ] CRLF line endings for `.ahk` files
- [ ] Scripts tested locally
- [ ] No hardcoded paths (use `A_ScriptDir`, environment variables)
- [ ] CI/CD checks pass

## Testing Guidelines

### Manual Testing

1. **Test in clean environment** when possible
2. **Verify all hotkeys** work as expected
3. **Test edge cases:**
   - Missing dependencies
   - Wrong paths
   - Admin privileges
   - Multiple monitors (if applicable)
4. **Check for errors** - No error dialogs or unexpected behavior

### AutoHotkey Script Testing

```bash
# Run script
Double-click script.ahk

# Check for syntax errors (compiles without running)
"C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in script.ahk /out temp.exe

# Clean up
del temp.exe
```

### Library Changes

When modifying shared libraries (`Lib/`):

1. Identify all scripts that include the library
2. Test at least 5 dependent scripts
3. Verify no regressions in existing functionality

### PowerShell Testing

```powershell
# Syntax check
pwsh -NoProfile -File script.ps1 -WhatIf

# Run with error handling
pwsh -NoProfile -File script.ps1
```

## Documentation

### When to Update Documentation

Update documentation when you:

- Add a new script or feature
- Change script behavior
- Fix a bug that affects usage
- Add new dependencies
- Change file structure

### Documentation Files

- **README.md** - User-facing overview and quick start
- **CLAUDE.md** - Developer guide and AI assistant instructions
- **CONTRIBUTING.md** - This file
- **Directory READMEs** - Specific documentation for subdirectories
- **Inline comments** - Complex logic and function documentation

### Documentation Standards

- Use **Markdown** format
- Include **code examples** where helpful
- Add **screenshots** for GUI features
- Keep **Table of Contents** updated
- Use **relative links** for internal references
- **Test all links** before committing

## Getting Help

### Resources

- [AutoHotkey Documentation](https://www.autohotkey.com/docs/)
- [AutoHotkey Forum](https://www.autohotkey.com/boards/)
- [CLAUDE.md](CLAUDE.md) - Comprehensive development guide
- [GitHub Issues](https://github.com/Ven0m0/Scripts/issues)

### Asking Questions

- Check existing [Issues](https://github.com/Ven0m0/Scripts/issues)
- Read [CLAUDE.md](CLAUDE.md) for common patterns
- Open a new issue with:
  - Clear description
  - Steps to reproduce (for bugs)
  - Expected vs actual behavior
  - System information

## Recognition

Contributors will be acknowledged in:

- Git commit history
- Release notes
- Project README (for significant contributions)

Thank you for contributing! 🎉
