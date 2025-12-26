# Robocopy Utilities

Batch script wrappers for Windows Robocopy command, optimized for fast file copying and filtering by extension.

## Overview

This directory contains CMD/Batch scripts that simplify using Microsoft's **Robocopy** (Robust File Copy) utility for common file management tasks. These scripts are pre-configured for specific use cases like copying images or performing fast mass copies.

## Features

- **Extension Filtering** - Copy only specific file types
- **Multi-threaded** - Faster copying with parallel operations  
- **Recursive** - Automatically copy subdirectories
- **Logging** - Optional copy operation logs
- **Simple Configuration** - Edit paths directly in script

## Scripts

| Script | Purpose |
|--------|---------|
| `Copy_images.cmd` | Copy image files (jpg, png, webp, bmp, ico) |
| `robocopy_wrapper.cmd` | General-purpose robocopy wrapper |
| `Fast_mass_copy.txt` | Documentation for fast copy parameters |

## Prerequisites

- **Windows 10/11** - Robocopy is built-in
- **Source files** - Files to copy
- **Destination folder** - Must exist or will be created

## Usage

### Copy Images

**Purpose:** Copy all image files from one location to another, including subdirectories.

1. **Edit the script** `Copy_images.cmd`:
   ```cmd
   set ext=*.jpg *.png *.webp *.bmp *.ico 
   robocopy "input Path" "output path" %ext% /s /MT:32
   ```

2. **Configure paths:**
   - Replace `"input Path"` with your source directory
   - Replace `"output path"` with your destination directory

3. **Run the script:**
   ```cmd
   Copy_images.cmd
   ```

## Customization

### Add More File Extensions

```cmd
set ext=*.jpg *.png *.gif *.svg *.webp
```

### Change Thread Count

```cmd
/MT:8   # Fewer threads (safer)
/MT:32  # Default (balanced)
/MT:64  # More threads (faster)
```

## Examples

### Copy Photos Only

```cmd
set ext=*.jpg *.jpeg *.png *.raw
robocopy "C:\Pictures" "D:\Backup" %ext% /s /MT:32
```

### Copy Videos

```cmd
set ext=*.mp4 *.mkv *.avi *.mov
robocopy "D:\Videos" "E:\Backup" %ext% /s /MT:16
```

## Resources

- [Robocopy Documentation](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy)
- [Fast_mass_copy.txt](Fast_mass_copy.txt) - Additional parameters

## Contributing

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for contribution guidelines.

---

**Last Updated:** 2025-12-26
