# Robocopy Utilities

Scripts wrapping Windows Robocopy for fast, filtered file copying.

## Overview

This directory contains a PowerShell script and a CMD wrapper that simplify using Microsoft's **Robocopy** (Robust File Copy) utility for common file management tasks: copying images by extension or general-purpose mass copies.

## Features

- **Extension Filtering** - Copy only specific file types
- **Multi-threaded** - Faster copying with parallel operations
- **Recursive** - Automatically copy subdirectories
- **Logging** - Optional copy operation logs

## Scripts

| Script | Purpose |
|--------|---------|
| `Copy-Images.ps1` | Copy image files (jpg, png, webp, bmp, ico) via robocopy |
| `robocopy_wrapper.cmd` | General-purpose robocopy wrapper for files or directories, with rename support |

## Prerequisites

- **Windows 10/11** - Robocopy is built-in
- **PowerShell 5.1+** - For `Copy-Images.ps1`
- **Source files** - Files to copy
- **Destination folder** - Must exist or will be created

## Usage

### Copy Images

```powershell
.\Copy-Images.ps1 -Source "C:\Pictures" -Destination "D:\Backup\Pictures" -Threads 32
```

### General-Purpose Copy

```cmd
robocopy_wrapper.cmd "C:\Source\file.txt" "D:\Dest\file.txt"
```

## Customization

### Fast Mass Copy

```cmd
robocopy "%userprofile%\Downloads\test" "%userprofile%\Downloads\test2" /MT:32 /E /NS /NC /NFL /NDL /NJH /LOG:C:\Robocopy.log
xcopy "%userprofile%\Downloads\test" "%userprofile%\Downloads\test2" /s /e /t /b /j /compress
```

### Change Thread Count

```cmd
/MT:8   # Fewer threads (safer)
/MT:32  # Default (balanced)
/MT:64  # More threads (faster)
```

## Resources

- [Robocopy Documentation](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy)

---

**Last Updated:** 2026-08-10
