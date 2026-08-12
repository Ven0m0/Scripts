# Minecraft AFK Macros

AutoHotkey v2 macros for Minecraft AFK farming and movement.

## Scripts

### MC_AFK.ahk

Java Edition fishing/eating loop.

- `F7` - Toggle AFK fishing loop
- `F6` - Toggle auto-eat (food slot 6) every 60s
- `F8` - Pause the script
- `F9` - Exit the script

### MC_AutoSprint.ahk

Bedrock Edition auto-sprint. Active only while `Minecraft.Windows.exe` is focused
(`#HotIf WinActive(...)`): holding `W` also holds `Ctrl` (Bedrock's sprint bind) for as
long as `W` is held.

## Usage

```bash
"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" MC_AFK.ahk
```

Position your character at the farm/fishing spot before starting a loop.

---

- [ahk/README.md](../README.md) - parent directory documentation
- [AGENTS.md](../../AGENTS.md) - developer guide
