# Citra 3DS Mod Manager

GUI-based mod manager for Citra 3DS emulator with HD texture pack support.

## Overview

These AutoHotkey v1 scripts provide a graphical interface for managing mods and HD texture packs for Nintendo 3DS games in the Citra emulator. Easily enable/disable mods without manually editing configuration files or moving directories.

## Features

- **Mod Management** - Enable/disable mods per game
- **HD Texture Packs** - Toggle high-resolution texture packs
- **Game Database** - CSV-based game configuration
- **GUI Interface** - No command-line or manual file editing required
- **Per-Game Settings** - Separate mod configurations for each game

## Scripts

| Script | Purpose |
|--------|---------|
| `Citra_Mod_Manager.ahk` | Main mod manager (mods and cheat codes) |
| `Citra_3DS_Manager.ahk` | HD texture pack manager |
| `Destination.csv` | Game database (name and title ID) |

## Prerequisites

### Required Software

- **Citra Emulator** - [Download](https://citra-emu.org/)
- **AutoHotkey v1.1.37.02+** - [Download](https://www.autohotkey.com/)
- **3DS Game ROMs** - Legal backups of games you own
- **Mods/Texture Packs** (optional) - Downloaded from community

## Installation

### Step 1: Configure File Paths

Both scripts require you to **edit the file paths** to match your system.

**Citra_Mod_Manager.ahk:**
```autohotkey
; Edit these paths in the script
CitraModsPath := "C:\Users\YourName\AppData\Roaming\Citra\load\mods"
CitraConfigPath := "C:\Users\YourName\AppData\Roaming\Citra\config"
```

**Citra_3DS_Manager.ahk:**
```autohotkey
; Edit these paths in the script
CitraDataPath := "C:\Users\YourName\AppData\Roaming\Citra"
TexturePacksPath := CitraDataPath . "\load\textures"
```

### Step 2: Add Games to Database

Edit `Destination.csv` to add your games:

```csv
Game Name,Title ID
Super Mario 3D Land,0004000000053F00
New Super Mario Bros,000400000007AF00
Mario Kart 7,0004000000030700
```

**Format:**
- Column 1: Friendly game name (any name you want)
- Column 2: 16-digit title ID (must be exact)

**Finding Title IDs:**

1. **Method 1: From Citra**
   - Right-click game in Citra
   - Select "Properties" or "Open Mod Location"
   - The folder name is the title ID

2. **Method 2: From 3DS Database**
   - Search: [3dsdb.com](https://www.3dsdb.com/)
   - Or check: [Citra Compatibility List](https://citra-emu.org/game/)

3. **Method 3: From File Name**
   - Some ROM files include the title ID in the name
   - Format: `[Title ID]`

**Example entries:**
```csv
The Legend of Zelda: Ocarina of Time 3D,0004000000033500
Pokemon X,0004000000055D00
Pokemon Y,0004000000055E00
Animal Crossing: New Leaf,0004000000086300
Fire Emblem Awakening,0004000000049000
```

### Step 3: Organize Mod Files

**Citra mod structure:**
```
C:\Users\YourName\AppData\Roaming\Citra\load\
├── mods\
│   └── [Title ID]\          # e.g., 0004000000053F00
│       ├── mod1\
│       │   └── romfs\
│       └── mod2\
│           └── code.ips
└── textures\
    └── [Title ID]\          # e.g., 0004000000053F00
        └── tex1_*.png
```

**Where to find mods:**
- [GameBanana](https://gamebanana.com/games/4965)
- [Citra Community Forums](https://community.citra-emu.org/)
- [Reddit r/Citra](https://reddit.com/r/Citra)

### Step 4: Keep Files Together

Ensure these files are in the same folder:
```
Other/Citra_mods/
├── Citra_Mod_Manager.ahk
├── Citra_3DS_Manager.ahk
└── Destination.csv
```

## Usage

### Managing Mods

1. **Launch the mod manager:**
   ```bash
   Citra_Mod_Manager.ahk
   ```

2. **Select a game** from the dropdown list

3. **Enable/disable mods** using checkboxes

4. **Apply changes** and restart Citra

### Managing HD Texture Packs

1. **Launch the texture manager:**
   ```bash
   Citra_3DS_Manager.ahk
   ```

2. **Select a game** from the list

3. **Toggle HD textures** on/off

4. **Apply settings** - Citra config is updated automatically

## Configuration

### Adding More Games

1. Open `Destination.csv`
2. Add a new line:
   ```csv
   Game Name,Title ID
   ```
3. Save the file
4. Restart the manager script

### Changing Citra Paths

If you use a portable Citra installation or custom paths:

```autohotkey
; Edit in Citra_Mod_Manager.ahk
CitraModsPath := "D:\Emulators\Citra\user\load\mods"

; Edit in Citra_3DS_Manager.ahk
CitraDataPath := "D:\Emulators\Citra\user"
```

### Custom Mod Locations

If your mods are in a different location:

```autohotkey
; Edit in the script
CustomModPath := "D:\My3DSMods"
```

## Troubleshooting

### Issue: Games not showing in dropdown

**Cause:** `Destination.csv` not found or incorrectly formatted

**Solution:**
1. Verify `Destination.csv` is in the same folder as the script
2. Check CSV format (comma-separated, no extra spaces)
3. Ensure no empty lines at the end

### Issue: Mods not applying

**Cause:** Incorrect file paths or title IDs

**Solution:**
1. Verify Citra paths in script match your installation
2. Double-check title ID is **exact** (16 characters)
3. Ensure mod files are in correct folder structure
4. Restart Citra after applying changes

### Issue: Script crashes on launch

**Cause:** AutoHotkey v1 not installed or wrong version

**Solution:**
1. Install AutoHotkey v1.1.37.02+
2. Right-click script → "Run as Administrator"

### Issue: HD textures not loading

**Cause:** Citra config not updated or cache issue

**Solution:**
1. Clear Citra shader cache
2. Check `qt-config.ini` for correct settings:
   ```ini
   [Renderer]
   use_custom_textures=true
   ```
3. Ensure texture pack files are in correct format

## Advanced Usage

### Batch Enable/Disable

Edit script to add "Enable All" / "Disable All" buttons:

```autohotkey
; Add to GUI
Gui Add, Button, gEnableAll, Enable All Mods

EnableAll:
  ; Loop through all checkboxes and enable
  Loop, Files, %CitraModsPath%\%CurrentTitleID%\*.*, D
  {
    ; Enable mod logic here
  }
Return
```

### Auto-Backup

Add automatic backup before changing settings:

```autohotkey
; Before modifying config
BackupFile := CitraConfigPath . "\qt-config.ini.bak"
FileCopy, %CitraConfigPath%\qt-config.ini, %BackupFile%, 1
```

## Known Limitations

1. **Requires manual path configuration** - No auto-detection
2. **CSV-based database** - Must be maintained manually
3. **Citra restart required** - Changes don't apply to running instance
4. **No mod download feature** - Must obtain mods separately

## Screenshot

![Citra Mod Manager](Citra_Mod_Manager.avif)

## Resources

- [Citra Emulator](https://citra-emu.org/)
- [Citra Mods Guide](https://citra-emu.org/wiki/user-directory/)
- [3DS Title ID Database](https://www.3dsdb.com/)
- [GameBanana 3DS Mods](https://gamebanana.com/games/4965)

## See Also

- [Citra_per_game_config](../Citra_per_game_config/) - Per-game emulator settings
- [AutoStartManager](../AutoStartManager.ahk) - Auto-fullscreen for Citra

## Contributing

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for contribution guidelines.

---

**Last Updated:** 2025-12-26
