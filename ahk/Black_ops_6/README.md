# Black Ops 6 AFK Macros

AutoHotkey v2 AFK macros for Call of Duty: Black Ops 6.

## bo6-afk.ahk

Runs at `High` process priority. Each mode is mutually exclusive — starting one stops
whichever is currently running; pressing the same key again stops it.

- `F1` - Toggle Balcony loop
- `F2` - Toggle Bank Roof loop (basic)
- `F3` - Toggle Bank Roof loop + periodic loot walk
- `F4` - Toggle Bank Roof Always (continuous fire, no phase cycling)
- `F5` - Toggle Hold LMB (press/release)
- `F7` - Stop all loops
- `F9` - Exit the script

### Reusing from a wrapper script

```autohotkey
g_registerDefaultHotkeys := false   ; before #Including, to skip default hotkeys
g_autostartMode := "balcony"        ; optional: auto-start a mode on load
#Include bo6-afk.ahk
```

## Safety

Automated input on a live multiplayer/anti-cheat service carries an account-ban risk under
the game's terms of service. Use at your own risk, and prefer offline/private modes.

---

- [ahk/README.md](../README.md) - parent directory documentation
- [AGENTS.md](../../AGENTS.md) - developer guide
