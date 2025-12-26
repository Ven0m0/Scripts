# 7zEmuPrepper

On-the-fly game decompression utility for emulation front-ends. Based on [7zEmuPrepper by UnluckyForSome](https://github.com/UnluckyForSome/7zEmuPrepper).

## Overview

7zEmuPrepper is a utility that decompresses disc-based games **on-the-fly** when launching from emulation front-ends like Playnite, Launchbox, or EmulationStation. This allows you to keep games compressed in 7z format, saving significant disk space while still being able to launch them normally.

## Features

- **Automatic Decompression** - Games are extracted when launched
- **Space Saving** - Keep games compressed (saves 50-80% disk space)
- **Front-end Integration** - Works with Playnite, Launchbox, etc.
- **7-Zip Support** - Uses 7-Zip for maximum compression
- **Transparent** - Games launch as if uncompressed
- **No Manual Work** - Set it up once and forget it

## How It Works

1. You compress your game files to `.7z` format
2. Configure your front-end to use 7zEmuPrepper as a launcher
3. When you launch a game:
   - 7zEmuPrepper extracts the game to a temporary location
   - The emulator launches with the extracted file
   - After closing, the temporary files are cleaned up
4. Your compressed archive remains intact

## Prerequisites

- **7-Zip** - [Download](https://www.7-zip.org/)
- **PowerShell 5.1+** or **PowerShell 7+**
- **Windows 10/11**
- **Emulation Front-end** (Playnite, Launchbox, etc.)
- **Compressed game files** (.7z format)

## Installation

### Step 1: Install 7-Zip

Download and install 7-Zip from [7-zip.org](https://www.7-zip.org/)

### Step 2: Compress Your Games

```powershell
# Compress a game folder
7z a -t7z -mx=9 "GameName.7z" "GameFolder\*"

# Compress with ultra compression
7z a -t7z -mx=9 -m0=lzma2 -mmt=on "GameName.7z" "GameFolder\*"
```

**Recommended structure:**
```
D:\Games\PS2\
├── Game1.7z
├── Game2.7z
└── Game3.7z
```

### Step 3: Configure Front-End

#### For Playnite

1. **Edit game** in Playnite
2. **Set Actions:**
   - Name: `Play`
   - Type: `File`
   - Path: `powershell.exe`
   - Arguments: `-ExecutionPolicy Bypass -File "path\to\7zEmuPrepper.ps1" -Archive "{ImagePath}" -Emulator "emulator.exe"`
   - Working Directory: `{InstallDir}`

#### For Launchbox

1. **Edit Emulator**
2. **Command-line parameters:**
   ```
   powershell.exe -ExecutionPolicy Bypass -File "path\to\7zEmuPrepper.ps1" -Archive "%rompath%\%romfile%" -Emulator "emulator.exe"
   ```

## Files

| File | Purpose |
|------|---------|
| `7zEmuPrepper.ps1` | Main PowerShell script |
| `Final.ahk` | AutoHotkey v2 launcher wrapper |
| `ps2exe.ps1` | Script to compile PS1 to EXE (optional) |
| `README.md` | This file |

## Usage

### PowerShell Script

```powershell
.\7zEmuPrepper.ps1 -Archive "Game.7z" -Emulator "emulator.exe"
```

**Parameters:**
- `-Archive` - Path to compressed game file (.7z)
- `-Emulator` - Emulator executable to launch
- `-TempDir` (optional) - Custom temporary extraction directory

### AutoHotkey Wrapper

The `Final.ahk` script provides an AutoHotkey interface:

```ahk
; Edit Final.ahk with your paths
Run "powershell.exe -File 7zEmuPrepper.ps1 -Archive 'Game.7z' -Emulator 'emulator.exe'"
```

## Configuration

### Custom Temp Directory

By default, games are extracted to `%TEMP%\7zEmuPrepper\`. To change:

```powershell
.\7zEmuPrepper.ps1 -Archive "Game.7z" -Emulator "emulator.exe" -TempDir "D:\Temp"
```

### Emulator Parameters

Pass additional parameters to the emulator:

```powershell
.\7zEmuPrepper.ps1 -Archive "Game.7z" -Emulator "emulator.exe -fullscreen -gpu opengl"
```

## Trade-offs

### Advantages ✅

- **Huge space savings** (50-80% reduction)
- **No manual decompression** needed
- **Original archives remain intact**
- **Works with any emulator**

### Disadvantages ❌

- **Longer launch time** (depends on game size and CPU)
- **Requires disk space** for temporary extraction
- **Adds complexity** to your setup

## Performance

**Extraction times** (approximate, depends on CPU):

| Game Size (Uncompressed) | Compressed Size | Extraction Time |
|--------------------------|-----------------|-----------------|
| 500 MB | ~200 MB | 5-10 seconds |
| 2 GB | ~800 MB | 15-30 seconds |
| 4 GB | ~1.5 GB | 30-60 seconds |
| 8 GB | ~3 GB | 1-2 minutes |

**Recommended for:**
- Games you play occasionally
- Large game collections with limited disk space
- Slower systems (extraction is CPU-bound, not disk-bound)

**NOT recommended for:**
- Games you play frequently (keep uncompressed)
- Very large games (>10 GB) unless you have fast CPU
- Systems with slow HDDs (extraction + disk IO = slow)

## Troubleshooting

### Issue: "7-Zip not found" error

**Solution:**
1. Install 7-Zip from [7-zip.org](https://www.7-zip.org/)
2. Verify installation: `7z --help`
3. Add 7-Zip to PATH if needed

### Issue: Game doesn't launch

**Solution:**
1. Test extraction manually: `7z x Game.7z`
2. Verify emulator path is correct
3. Check PowerShell execution policy: `Get-ExecutionPolicy`
4. Enable script execution: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`

### Issue: Temp files not cleaned up

**Solution:**
1. Manually delete: `%TEMP%\7zEmuPrepper\`
2. Check script has permissions to delete
3. Close emulator properly (don't force kill)

### Issue: Extraction too slow

**Solution:**
1. Use faster compression level when creating archives: `-mx=5` instead of `-mx=9`
2. Store frequently-played games uncompressed
3. Use SSD for temp directory
4. Upgrade CPU (extraction is CPU-intensive)

## Advanced Usage

### Compile PowerShell to EXE

Use `ps2exe.ps1` to create a standalone executable:

```powershell
.\ps2exe.ps1 -InputFile 7zEmuPrepper.ps1 -OutputFile 7zEmuPrepper.exe
```

Benefits:
- No need to set PowerShell execution policy
- Easier to distribute
- Slightly faster startup

### Batch Compress Games

```powershell
# Compress all games in a directory
Get-ChildItem -Directory | ForEach-Object {
    7z a -t7z -mx=9 "$($_.Name).7z" "$($_.FullName)\*"
}
```

### Integration with Emulation Station

Edit `es_systems.cfg`:

```xml
<command>powershell.exe -ExecutionPolicy Bypass -File "path\to\7zEmuPrepper.ps1" -Archive "%ROM%" -Emulator "emulator.exe"</command>
```

## Best Practices

1. **Test first** - Try with one game before compressing your entire library
2. **Keep backups** - Don't delete originals until you verify compressed versions work
3. **Optimize compression** - Balance between file size and extraction time
4. **Use for archives** - Best for games you don't play often
5. **Monitor temp space** - Ensure enough space for largest game

## Compression Recommendations

### Maximum Compression (Slowest)

```bash
7z a -t7z -mx=9 -m0=lzma2 -mmt=on "Game.7z" "Game\*"
```
- Best compression ratio
- Slowest compression and extraction
- Use for long-term storage

### Balanced (Recommended)

```bash
7z a -t7z -mx=7 "Game.7z" "Game\*"
```
- Good compression ratio
- Reasonable extraction speed
- Best for most users

### Fast (Least Compression)

```bash
7z a -t7z -mx=3 "Game.7z" "Game\*"
```
- Lower compression ratio
- Fastest extraction
- Use for frequently-played games

## Resources

- [Original 7zEmuPrepper Project](https://github.com/UnluckyForSome/7zEmuPrepper)
- [7-Zip Official Site](https://www.7-zip.org/)
- [7-Zip Command Line Documentation](https://sevenzip.osdn.jp/chm/cmdline/index.htm)

## See Also

- [AutoStartManager](../AutoStartManager.ahk) - Auto-fullscreen for emulators
- [Playnite_fullscreen_v2](../Playnite_fullscreen_v2/) - Playnite automation

## Contributing

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for contribution guidelines.

---

**Note:** This is a fork/adaptation of the original 7zEmuPrepper project. The caveat is that launch times will be longer due to on-the-fly decompression.

**Last Updated:** 2025-12-26
