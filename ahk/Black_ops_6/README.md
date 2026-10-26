# Black Ops 6 AFK Macros

AutoHotkey v2 AFK macros for Call of Duty: Black Ops 6.

## bo6-afk.ahk

Runs at `High` process priority. Each mode is mutually exclusive — starting one stops
whichever is currently running; pressing the same key again stops it.

- `F1` - Toggle Balcony loop (start prone under the desk, Jet Gun in slot 2)
- `F2` - Toggle Bank Roof loop (basic)
- `F3` - Toggle Bank Roof loop + periodic loot walk
- `F4` - Toggle Bank Roof Always (continuous fire, no phase cycling)
- `F5` - Toggle Hold LMB (press/release)
- `F7` - Stop all loops
- `F9` - Exit the script

### Balcony setup (F1)

1. Reach the Liberty Falls church balcony manually (Aether Shroud + Burst Dash, from a pew or a rock).
2. Go prone under the desk, facing the zombies below.
3. Have the Jet Gun in slot 2, `p` bound to prone (toggle), and ADS on right mouse.
4. The loop stands up, selects the Jet Gun, holds ADS for the blast, then equips the knife (`3`,
   the game won't go prone with the Jet Gun in hand), waits 1 s for the switch animation, and goes
   prone again. The
   blast drains the Jet Gun's charge; the ~80 s cycle is meant to let it recharge (not verified).
5. The script never moves the mouse, so the blast goes wherever the camera already points.
6. Best Directed Mode round to farm: round 11. It has no Manglers and the most zombies of any
   Mangler-free round. A Mangler as the last zombie
   can't be killed by the loop.

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
