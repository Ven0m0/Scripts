# Citra Per-Game Configuration

AutoHotkey v1 scripts for automatically applying per-game configuration settings to the Citra 3DS emulator.

## Overview

This collection of scripts allows you to automatically configure Citra emulator settings for specific games. When launched, these scripts modify Citra's `qt-config.ini` file to enable or disable features like:

- HD textures
- Custom shaders
- Resolution scaling
- Audio settings
- Input configurations
- Performance optimizations

## Features

- **Per-Game Profiles** - Different settings for each game
- **Automatic Configuration** - Applies settings before launching
- **Easy Customization** - Duplicate and modify existing profiles
- **Safe Defaults** - Base configuration to restore standard settings
- **INI File Management** - Uses tf.ahk library for reliable editing

## Scripts

| Script | Purpose |
|--------|---------|
| `Citra-base.ahk` | Base configuration template |
| `Citra-per-game.ahk` | Template for per-game configurations |
| `Default.ahk` | Restore default Citra settings |
| `tf.ahk` | Text file manipulation library (required) |

## Prerequisites

- **Citra Emulator** - [Download](https://citra-emu.org/)
- **AutoHotkey v1.1.37.02+** - [Download](https://www.autohotkey.com/)
- **3DS Game ROMs** - Legal backups of games you own

## Installation

### Step 1: Configure File Paths

**IMPORTANT:** You must edit file paths in each script to match your system.

Open any `.ahk` script and find this line:
```autohotkey
global CitraConfigFile := "C:\Users\YourName\AppData\Roaming\Citra\config\qt-config.ini"
```

Change to your actual path:
```autohotkey
; Find your Citra config folder:
; Usually: C:\Users\[YourUsername]\AppData\Roaming\Citra\config\
global CitraConfigFile := "C:\Users\ActualUsername\AppData\Roaming\Citra\config\qt-config.ini"
```

**Finding your Citra config:**
1. Press `Win+R`
2. Type: `%appdata%\Citra\config`
3. Press Enter
4. Copy the full path shown in Explorer's address bar
5. Add `\qt-config.ini` at the end

### Step 2: Keep Files Together

Ensure all files are in the same directory:
```
Other/Citra_per_game_config/
├── Citra-base.ahk
├── Citra-per-game.ahk
├── Default.ahk
└── tf.ahk              # REQUIRED - Do not delete!
```

**⚠️ Important:** `tf.ahk` must be in the same folder as the other scripts!

### Step 3: Backup Original Config

Before using these scripts:
```bash
# Navigate to Citra config folder
cd %appdata%\Citra\config

# Create backup
copy qt-config.ini qt-config.ini.backup
```

## Usage

### Using Pre-Configured Game Profiles

1. **Edit the script** for your game
2. **Update file paths** (see Installation)
3. **Run the script:**
   ```bash
   # Double-click the .ahk file
   Citra-per-game.ahk
   ```
4. **Launch Citra** normally - settings are applied

### Restoring Default Settings

```bash
# Run the default script
Default.ahk

# Or manually restore backup
copy qt-config.ini.backup qt-config.ini
```

## Creating Custom Game Profiles

### Method 1: Duplicate Existing Script

1. **Copy** `Citra-per-game.ahk`
2. **Rename** to your game:
   ```
   Pokemon-X.ahk
   Zelda-OOT.ahk
   ```
3. **Edit** the settings inside
4. **Update** file paths

### Method 2: Start from Template

**Template structure:**
```autohotkey
#Include %A_ScriptDir%\tf.ahk

; ============================================
; Game: Your Game Name
; ============================================

; Set your Citra config path
global CitraConfigFile := "C:\Users\YourName\AppData\Roaming\Citra\config\qt-config.ini"

; Enable HD Textures
tf_Replace(CitraConfigFile, "custom_textures\use_custom_textures=false", "custom_textures\use_custom_textures=true")

; Set Resolution Scale
tf_Replace(CitraConfigFile, "resolution_factor\default=true", "resolution_factor\default=false")
tf_Replace(CitraConfigFile, "resolution_factor=1", "resolution_factor=3")

; Enable VSYNC
tf_Replace(CitraConfigFile, "use_vsync_new=false", "use_vsync_new=true")

MsgBox, Configuration applied for Your Game Name!
ExitApp
```

## Common Settings

### Graphics Settings

**Enable HD Textures:**
```autohotkey
tf_Replace(CitraConfigFile, "custom_textures\use_custom_textures=false", "custom_textures\use_custom_textures=true")
```

**Resolution Scaling:**
```autohotkey
; Disable auto resolution
tf_Replace(CitraConfigFile, "resolution_factor\default=true", "resolution_factor\default=false")

; Set scale (1-10)
tf_Replace(CitraConfigFile, "resolution_factor=1", "resolution_factor=3")
; 1 = Native (400x240)
; 2 = 2x (800x480)
; 3 = 3x (1200x720)
; 4 = 4x (1600x960)
```

**Enable Shaders:**
```autohotkey
tf_Replace(CitraConfigFile, "shaders_accurate_mul=false", "shaders_accurate_mul=true")
```

### Performance Settings

**Enable Frame Limit:**
```autohotkey
tf_Replace(CitraConfigFile, "use_frame_limit=false", "use_frame_limit=true")
tf_Replace(CitraConfigFile, "frame_limit=100", "frame_limit=100")
```

**Enable VSync:**
```autohotkey
tf_Replace(CitraConfigFile, "use_vsync_new=false", "use_vsync_new=true")
```

**CPU Clock Speed:**
```autohotkey
tf_Replace(CitraConfigFile, "cpu_clock_percentage=100", "cpu_clock_percentage=150")
; 100 = Default
; 150 = 1.5x speed (may improve performance)
```

### Audio Settings

**Enable Audio Stretching:**
```autohotkey
tf_Replace(CitraConfigFile, "enable_audio_stretching=false", "enable_audio_stretching=true")
```

**Set Audio Backend:**
```autohotkey
tf_Replace(CitraConfigFile, "output_engine=auto", "output_engine=cubeb")
; Options: auto, cubeb, sdl2
```

## Finding INI Settings

### Method 1: Compare Configs

1. Make a backup: `copy qt-config.ini before.ini`
2. Change setting in Citra GUI
3. Close Citra
4. Compare files:
   ```bash
   fc before.ini qt-config.ini
   ```
5. Note the changed line

### Method 2: Search INI File

Open `qt-config.ini` in a text editor and search for:
- `[Renderer]` - Graphics settings
- `[System]` - CPU/Region settings
- `[Audio]` - Audio settings
- `[Controls]` - Input settings

## Troubleshooting

### Issue: Settings don't apply

**Cause:** Citra is running when script executes

**Solution:**
1. Close Citra completely
2. Run the configuration script
3. Launch Citra

### Issue: "File not found" error

**Cause:** Incorrect CitraConfigFile path

**Solution:**
1. Verify path is correct
2. Check for typos
3. Use full absolute path
4. Ensure `qt-config.ini` exists

### Issue: Script errors with tf.ahk

**Cause:** tf.ahk not in same folder

**Solution:**
1. Download or copy tf.ahk
2. Place in same directory as other scripts
3. Verify with: `dir tf.ahk`

### Issue: Settings revert after Citra closes

**Cause:** Citra overwrites config on exit

**Solution:**
- Apply settings while Citra is closed
- Or mark `qt-config.ini` as read-only (not recommended)

## Advanced Usage

### Backup Before Changes

```autohotkey
; Add at start of script
BackupFile := CitraConfigFile . ".backup-" . A_Now
FileCopy, %CitraConfigFile%, %BackupFile%
```

### Conditional Settings

```autohotkey
; Check current value before changing
currentValue := tf_ReadLine(CitraConfigFile, "resolution_factor=")

if (InStr(currentValue, "resolution_factor=1")) {
    ; Only change if currently at 1x
    tf_Replace(CitraConfigFile, "resolution_factor=1", "resolution_factor=3")
}
```

### Launch Citra After Config

```autohotkey
; At end of script, after applying settings
CitraPath := "C:\Program Files\Citra\citra-qt.exe"
GamePath := "D:\Games\3DS\MyGame.3ds"

Run, "%CitraPath%" "%GamePath%"
ExitApp
```

## Game-Specific Recommendations

### Pokemon X/Y
- Resolution: 2x-3x
- Enable HD textures if available
- CPU Clock: 100% (higher may cause issues)

### Legend of Zelda: Ocarina of Time 3D
- Resolution: 4x+
- Enable accurate shader multiplication
- HD textures strongly recommended

### Super Mario 3D Land
- Resolution: 3x-4x
- VSync: On
- Frame limit: 100%

## Known Limitations

1. **Manual path configuration required** - No auto-detection
2. **Citra must be closed** - Settings won't apply to running instance
3. **No GUI** - Command-line/script-based only
4. **Backup recommended** - No built-in config restore

## Resources

- [Citra Wiki - User Directory](https://citra-emu.org/wiki/user-directory/)
- [Citra Configuration Guide](https://citra-emu.org/wiki/dumping-save-data-from-a-3ds-console/)
- [tf.ahk Library](https://www.autohotkey.com/board/topic/78271-txt-file-manipulation-functions/)

## See Also

- [Citra_mods](../Citra_mods/) - Mod and texture pack manager
- [AutoStartManager](../AutoStartManager.ahk) - Auto-fullscreen for Citra

## Contributing

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for contribution guidelines.

---

**Last Updated:** 2025-12-26
