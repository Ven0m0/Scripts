# Black Ops 6 AFK Macros

This directory contains AutoHotkey v2 AFK (Away From Keyboard) macros for Call of Duty: Black Ops 6. These scripts automate repetitive actions for XP farming, camo grinding, and other in-game tasks.

## Scripts

### bo6-afk.ahk

**Purpose:** Main AFK macro for Black Ops 6

**Features:**
- Automated movement and actions
- Customizable timing patterns
- Pause/resume functionality
- Emergency stop hotkey
- Works in Zombies and multiplayer modes

**Hotkeys:**
- `F7` - Start macro
- `F8` - Pause/Resume
- `F9` - Emergency stop (exits script)

**Usage:**
```bash
# 1. Start Black Ops 6
# 2. Enter a game mode (Zombies, Multiplayer, etc.)
# 3. Run the macro
bo6-afk.ahk

# 4. Press F7 to start the macro
# 5. Press F8 to pause if needed
# 6. Press F9 to stop completely
```

**Configuration:**
The script includes customizable timing and actions. Edit the script to adjust:

```autohotkey
; Adjust timing (in milliseconds)
actionDelay := 1000  ; Time between actions
moveDelay := 500     ; Time for movement inputs

; Adjust actions
; Modify the Loop section to change what keys are pressed
```

## ⚠️ Important Warnings

### Game Terms of Service

**Use at your own risk!** Using automation macros may violate the game's Terms of Service and could result in:

- Temporary suspension
- Permanent ban
- Loss of progress
- Account termination

**We do not condone violating game ToS.** These scripts are provided for educational purposes and single-player/private use only.

### Anti-Cheat Detection

Call of Duty games have anti-cheat systems that may detect:

- Repeated patterns
- Inhuman timing
- Macro software

**Recommendations:**
- Only use in private/offline modes
- Add randomization to timing
- Don't run for extended periods
- Monitor your session

## Safety Features

### Built-in Safeguards

1. **Emergency Stop** - F9 immediately terminates the script
2. **Pause Function** - F8 allows you to pause without stopping
3. **Window Detection** - Script only runs when game is active (optional)

### Adding Window Detection

To make the macro only work when Black Ops 6 is active:

```autohotkey
; Add at top of script
#HotIf WinActive("ahk_exe cod.exe")  ; Replace with actual exe name

; Your hotkeys here
F7::StartMacro()
F8::Pause

#HotIf  ; End context

; Now hotkeys only work when game is focused
```

## Customization Guide

### Modifying Actions

**Example: Change movement pattern**

```autohotkey
; Original
Loop {
  Send("{w down}")
  Sleep(500)
  Send("{w up}")
  Sleep(1000)
}

; Modified: Circle movement
Loop {
  Send("{w down}{a down}")
  Sleep(500)
  Send("{w up}{a up}")
  Sleep(100)
  Send("{w down}{d down}")
  Sleep(500)
  Send("{w up}{d up}")
  Sleep(100)
}
```

### Adding Randomization

**Prevent detection with random timing:**

```autohotkey
; Add Random function helper
RandomDelay(min, max) {
  return Random(min, max)
}

; Use in loop
Loop {
  Send("{Space}")
  Sleep(RandomDelay(900, 1100))  ; Random delay between 900-1100ms
  Send("{Mouse1}")
  Sleep(RandomDelay(450, 550))
}
```

### Adding Mouse Movement

```autohotkey
; Random mouse movement
Loop {
  MouseMove(RandomDelay(-50, 50), RandomDelay(-50, 50), 0, "R")
  Sleep(1000)
}
```

## Use Cases

### 1. Zombies AFK

**Purpose:** Farm XP in Zombies mode

**Setup:**
1. Find a safe corner or camping spot
2. Set up equipment/defenses
3. Run macro with continuous shooting

**Macro pattern:**
```autohotkey
Loop {
  Send("{Mouse1 down}")  ; Hold fire
  Sleep(2000)
  Send("{Mouse1 up}")
  Sleep(500)
  Send("{r}")  ; Reload
  Sleep(2000)
}
```

### 2. Multiplayer Movement

**Purpose:** Avoid AFK kick in multiplayer

**Macro pattern:**
```autohotkey
Loop {
  Send("{w down}")
  Sleep(500)
  Send("{w up}")
  Sleep(500)
  Send("{s down}")
  Sleep(500)
  Send("{s up}")
  Sleep(5000)  ; Wait between movements
}
```

### 3. Camo Grinding

**Purpose:** Automate repetitive actions for camo challenges

**Macro pattern:**
```autohotkey
Loop {
  Send("{Mouse1}")  ; Fire
  Sleep(100)
  Send("{Mouse2}")  ; Aim
  Sleep(300)
  Send("{r}")  ; Reload
  Sleep(2000)
}
```

## Troubleshooting

### Issue: Macro doesn't work in game

**Possible causes:**
1. Game has focus protection
2. Running without admin privileges
3. Anti-cheat blocking

**Solutions:**
```ahk
; 1. Add admin requirement
#Include A_ScriptDir "\..\..\Lib\v2\AHK_Common.ahk"
InitScript(false, true)  ; Require admin

; 2. Use DirectInput instead
Send("{w down}")  ; Try this
SendEvent("{w down}")  ; Or this
```

### Issue: Actions are too fast/slow

**Solution:** Adjust Sleep times

```autohotkey
; Slow down
Sleep(2000)  ; Increase value

; Speed up
Sleep(500)  ; Decrease value

; Find the sweet spot for your game
```

### Issue: Character gets stuck

**Solution:** Add unstuck routine

```autohotkey
; Add to main loop
Loop {
  ; Normal actions
  Send("{w down}")
  Sleep(1000)
  Send("{w up}")
  
  ; Unstuck every 30 seconds
  if (Mod(A_Index, 30) == 0) {
    Send("{Space}")  ; Jump
    Sleep(200)
    Send("{s down}")  ; Move back
    Sleep(500)
    Send("{s up}")
  }
}
```

## Advanced Features

### Progress Tracking

**Track how long the macro has been running:**

```autohotkey
global startTime := 0
global totalRuns := 0

F7:: {
  global startTime, totalRuns
  startTime := A_TickCount
  totalRuns := 0
  
  Loop {
    ; Your actions here
    totalRuns++
    
    ; Show progress every 100 iterations
    if (Mod(totalRuns, 100) == 0) {
      elapsed := (A_TickCount - startTime) / 1000 / 60  ; Minutes
      ToolTip("Running: " Round(elapsed, 1) " min | Cycles: " totalRuns)
    }
  }
}
```

### Auto-Stop After Time

**Stop macro after X minutes:**

```autohotkey
F7:: {
  startTime := A_TickCount
  maxMinutes := 60  ; Run for 60 minutes
  
  Loop {
    ; Your actions here
    
    ; Check elapsed time
    elapsed := (A_TickCount - startTime) / 1000 / 60
    if (elapsed >= maxMinutes) {
      MsgBox("Macro complete! Ran for " maxMinutes " minutes")
      ExitApp
    }
  }
}
```

## Best Practices

1. **Start small** - Test macro for 5 minutes before long sessions
2. **Add breaks** - Include pauses every 10-15 minutes
3. **Randomize** - Add random delays to avoid patterns
4. **Monitor** - Check game periodically
5. **Respect ToS** - Only use in appropriate game modes
6. **Stay safe** - Don't violate game rules

## Resources

- [AutoHotkey v2 Documentation](https://www.autohotkey.com/docs/v2/)
- [Send Function](https://www.autohotkey.com/docs/v2/lib/Send.htm)
- [Mouse Commands](https://www.autohotkey.com/docs/v2/lib/Click.htm)
- [CLAUDE.md](../../CLAUDE.md) - Developer guide

## Contributing

When modifying or adding macros:

1. Test thoroughly in private/offline modes
2. Add comments explaining timing and actions
3. Include setup instructions
4. Warn about ToS implications
5. Add randomization where possible

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for detailed guidelines.

---

**Disclaimer:** Use these scripts responsibly and at your own risk. The authors are not responsible for any consequences of using these macros, including but not limited to account suspensions or bans.

**Last Updated:** 2025-12-26
