# ahk - AutoHotkey v2 Scripts

AutoHotkey v2.0 scripts for gaming automation, window management, and system utilities.

## Directory Structure

```
ahk/
├── Black_ops_6/         # Call of Duty Black Ops 6 AFK macros
├── Minecraft/           # Minecraft AFK/automation scripts
├── Robocopy/            # Robocopy wrapper for image backups
├── ControllerQuit.ahk   # Close active window with a controller button combo
├── Fullscreen.ahk       # Borderless fullscreen toggle
└── Keys.ahk             # General hotkey suite
```

## Scripts

### Fullscreen.ahk

Fake fullscreen toggle on the active window's own monitor.

- `End` - Toggle fake fullscreen; toggling off restores the previous size and position
- `Ctrl+Alt+End` - Same toggle, with always-on-top while fullscreen

Requires admin (via `InitScript`).

### ControllerQuit.ahk

Hold Joy9 (Select) + Joy10 (Start) on any detected controller to close the active window.

### Keys.ahk

General-purpose hotkey suite: window snapping, media keys, always-on-top toggle,
recycle bin/clipboard clear, file date-stamping, and a documentation GUI. See the script
for the full hotkey list.

### Black_ops_6/

AFK macros for Black Ops 6. See [Black_ops_6/README.md](Black_ops_6/README.md).

### Minecraft/

AFK farming and auto-sprint automation. See [Minecraft/README.md](Minecraft/README.md).

### Robocopy/

Robocopy-based image backup wrapper (PowerShell + cmd, not AHK). See
[Robocopy/README.md](Robocopy/README.md).

## Running Scripts

```bash
# Double-click, or from the command line:
"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" Fullscreen.ahk
```

## Development

All scripts require `#Requires AutoHotkey v2.0`, `#SingleInstance Force`, and reuse
`Lib/AHK_Common.ahk` / `Lib/WindowManager.ahk` where applicable — see
[AGENTS.md](../AGENTS.md) and [.claude/rules/autohotkey.md](../.claude/rules/autohotkey.md)
for conventions and CI requirements.

---

- [AGENTS.md](../AGENTS.md) - developer guide
- [Lib/README.md](../Lib/README.md) - shared helper reference
