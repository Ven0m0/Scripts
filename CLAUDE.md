# CLAUDE.md - AI Assistant Development Guide

> **Last Updated:** 2025-12-04
> **Purpose:** Comprehensive guide for AI assistants working with this codebase

---

## Table of Contents

1. [Repository Overview](#repository-overview)
2. [Codebase Structure](#codebase-structure)
3. [Development Workflows & CI/CD](#development-workflows--cicd)
4. [Coding Conventions & Standards](#coding-conventions--standards)
5. [Key Components & Libraries](#key-components--libraries)
6. [Common Patterns & Templates](#common-patterns--templates)
7. [Testing & Quality Assurance](#testing--quality-assurance)
8. [Known Issues & Technical Debt](#known-issues--technical-debt)
9. [Development Guidelines for AI Assistants](#development-guidelines-for-ai-assistants)

---

## Repository Overview

### Purpose

This repository is a **comprehensive automation toolkit** focused on Windows gaming/emulation workflows, with particular strengths in:

- **Window Management** - Borderless fullscreen, multi-monitor control, window snapping
- **Emulator Automation** - Auto-fullscreen for 15+ emulators (Citra, Yuzu, RPCS4, etc.)
- **Media Tools** - YouTube and Spotify downloaders with GUI
- **Gaming Utilities** - AFK macros, mod managers, per-game configs
- **System Enhancement** - Hotkey suites, power plan automation

### Key Statistics

- **Languages:** AutoHotkey v1.1 (primary), PowerShell, Batch
- **Total Scripts:** 61 AutoHotkey files, 2 PowerShell scripts, 3 CMD files
- **License:** MIT (permissive)
- **Author:** Ven0m0 (ven0m0.wastaken@gmail.com)
- **Platform:** Windows-only (CRLF line endings, Windows-specific APIs)

### Core Philosophy

1. **Performance-First** - Heavy optimization in all scripts
2. **Modular Design** - Shared libraries in `Lib/` directory
3. **Minimal Dependencies** - Pure AHK where possible
4. **User Convenience** - GUI tools for non-technical users
5. **Gaming Focus** - Emulator and game automation priority

---

## Codebase Structure

### Root Directory Layout
