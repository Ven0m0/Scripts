# Minecraft AFK Macros

This directory contains AutoHotkey v2 AFK (Away From Keyboard) macros for Minecraft. These scripts automate repetitive tasks like fishing, farming, and mob grinding.

## Scripts

### MC_AFK.ahk

**Purpose:** General-purpose AFK macro for Minecraft Java Edition

**Features:**
- AFK fishing automation
- Auto-farming (crops, melons, etc.)
- Mob grinder automation
- Customizable timing
- Pause/resume functionality

**Hotkeys:**
- `F7` - Start macro
- `F8` - Pause/Resume
- `F9` - Emergency stop (exits script)

**Usage:**
```bash
# 1. Start Minecraft
# 2. Set up your AFK farm/fishing spot
# 3. Position your character correctly
# 4. Run the macro
MC_AFK.ahk

# 5. Press F7 to start
# 6. Press F8 to pause
# 7. Press F9 to stop
```

---

### MC_Bedrock.ahk

**Purpose:** Minecraft Bedrock Edition specific macro

**Features:**
- Optimized for Bedrock Edition controls
- Touch-friendly input timing
- Bedrock-specific mechanics support
- Console/Windows 10 compatible

**Usage:**
Same as MC_AFK.ahk but optimized for Bedrock Edition

---

## Common Use Cases

### 1. AFK Fishing

**Purpose:** Automatically fish while AFK

**Setup:**
1. Make an AFK fishing farm (search YouTube for designs)
2. Stand in the correct position
3. Hold fishing rod
4. Run macro

**Macro pattern:**
```autohotkey
Loop {
  Send("{Mouse2}")  ; Cast fishing rod
  Sleep(RandomDelay(1000, 2000))  ; Wait for bite
  
  ; Detect bite (pixel color check or timer)
  Sleep(RandomDelay(500, 1000))
  
  Send("{Mouse2}")  ; Reel in
  Sleep(500)
}

RandomDelay(min, max) {
  return Random(min, max)
}
```

**Tips:**
- Use note blocks or redstone to detect bites
- Add randomization to avoid detection
- Monitor inventory space

---

### 2. Auto-Farming

**Purpose:** Harvest and replant crops automatically

**Setup:**
1. Create rows of crops (wheat, carrots, potatoes)
2. Position at start of first row
3. Run macro

**Macro pattern:**
```autohotkey
Loop {
  ; Move forward
  Send("{w down}")
  Sleep(500)
  Send("{w up}")
  
  ; Break and replant
  Send("{Mouse1}")  ; Break
  Sleep(100)
  Send("{Mouse2}")  ; Plant
  Sleep(500)
  
  ; Turn at end of row
  if (Mod(A_Index, 10) == 0) {
    Send("{d down}")
    Sleep(200)
    Send("{d up}")
  }
}
```

---

### 3. Mob Grinder

**Purpose:** Collect items from mob grinder

**Setup:**
1. Build mob grinder with collection point
2. Stand at collection point
3. Run macro

**Macro pattern:**
```autohotkey
Loop {
  Send("{Mouse1}")  ; Attack
  Sleep(500)
  
  ; Collect items periodically
  if (Mod(A_Index, 20) == 0) {
    Send("{e}")  ; Open inventory
    Sleep(500)
    ; Sort items here if needed
    Send("{Escape}")  ; Close inventory
  }
}
```

---

### 4. Auto-Clicker

**Purpose:** Hold down a button/action

**Macro pattern:**
```autohotkey
F7:: {
  Loop {
    Send("{Mouse1}")  ; Left click
    Sleep(50)  ; Very fast clicking
  }
}
```

---

## Advanced Features

### Smart AFK Fishing

**Detects when fish bites using pixel color:**

```autohotkey
F7:: {
  ; Get reference color of bobber float
  MouseGetPos(&x, &y)
  baseColor := PixelGetColor(x, y)
  
  Loop {
    Send("{Mouse2}")  ; Cast
    Sleep(500)
    
    ; Wait for color change (bite)
    Loop {
      currentColor := PixelGetColor(x, y)
      if (currentColor != baseColor) {
        Sleep(100)
        Send("{Mouse2}")  ; Reel in
        break
      }
      Sleep(100)
      
      ; Timeout after 30 seconds
      if (A_Index > 300) {
        Send("{Mouse2}")  ; Recast
        break
      }
    }
    
    Sleep(2000)
  }
}
```

### Auto-Breeding Animals

**Automatically breed animals:**

```autohotkey
F7:: {
  Loop {
    ; Hold wheat/carrots
    Send("{1}")  ; Switch to hotbar slot 1
    Sleep(500)
    
    ; Right-click animals
    Loop 5 {
      Send("{Mouse2}")
      Sleep(100)
      MouseMove(50, 0, 10, "R")  ; Move mouse to next animal
    }
    
    ; Wait for breeding cooldown
    Sleep(5 * 60 * 1000)  ; 5 minutes
  }
}
```

### Elytra Auto-Boost

**Automatically use firework rockets while flying:**

```autohotkey
; Hold this key while flying
$Space:: {
  Send("{Space}")
  if GetKeyState("Space", "P") {
    Sleep(1000)
    Send("{Mouse2}")  ; Use firework
  }
}
```

## Customization Guide

### Adjusting Timing

**For different computers/servers:**

```autohotkey
; Variables for timing
global actionDelay := 1000  ; Milliseconds between actions
global moveDelay := 500     ; Movement duration
global waitDelay := 2000    ; Wait between cycles

; Use in script
Sleep(actionDelay)
```

### Adding Anti-AFK Movement

**Prevent being kicked for AFK:**

```autohotkey
F7:: {
  Loop {
    ; Main actions here
    Send("{Mouse1}")
    Sleep(1000)
    
    ; Anti-AFK movement every 60 seconds
    if (Mod(A_Index, 60) == 0) {
      Send("{w down}")
      Sleep(100)
      Send("{w up}")
      Sleep(100)
      Send("{a down}")
      Sleep(100)
      Send("{a up}")
    }
  }
}
```

### Inventory Management

**Auto-sort or drop items:**

```autohotkey
; Drop unwanted items
DropJunk() {
  Send("{e}")  ; Open inventory
  Sleep(500)
  
  ; Drop items from specific slots
  Loop 9 {
    Send("{" A_Index "}")  ; Select slot
    Sleep(50)
    Send("{q}")  ; Drop item
    Sleep(50)
  }
  
  Send("{Escape}")  ; Close inventory
}

; Call periodically
if (Mod(A_Index, 100) == 0) {
  DropJunk()
}
```

## Safety Features

### Server-Friendly Settings

**Avoid getting kicked or banned:**

1. **Add randomization** to all timing
2. **Include breaks** every 30-60 minutes
3. **Monitor chat** for admin messages
4. **Check inventory** to prevent overflow
5. **Test in single-player** first

### Example: Safe Fishing Macro

```autohotkey
F7:: {
  startTime := A_TickCount
  cycleCount := 0
  
  Loop {
    ; Random delay between casts
    Send("{Mouse2}")
    Sleep(RandomDelay(1000, 3000))
    
    ; Wait for bite (randomized)
    Sleep(RandomDelay(10000, 20000))
    
    ; Reel in
    Send("{Mouse2}")
    Sleep(RandomDelay(500, 1000))
    
    cycleCount++
    
    ; Take break every 30 minutes
    elapsed := (A_TickCount - startTime) / 1000 / 60
    if (elapsed > 30 and Mod(cycleCount, 100) == 0) {
      TakeBreak()
      startTime := A_TickCount
    }
  }
}

TakeBreak() {
  MsgBox("Taking a 5-minute break...", , "T300")
  Sleep(5 * 60 * 1000)
}

RandomDelay(min, max) {
  return Random(min, max)
}
```

## Troubleshooting

### Issue: Macro stops working

**Possible causes:**
1. Minecraft lost focus
2. Inventory full
3. Died or respawned
4. Server lag

**Solutions:**
```ahk
; Add window detection
#HotIf WinActive("ahk_exe javaw.exe")  ; Java Edition
; or
#HotIf WinActive("ahk_exe Minecraft.Windows.exe")  ; Bedrock

; Add inventory check
CheckInventory() {
  Send("{e}")
  Sleep(500)
  ; Check if inventory is full (implementation depends on method)
  Send("{Escape}")
}
```

### Issue: Character moves incorrectly

**Solution:** Adjust movement timing

```ahk
; Increase delays for laggy servers
Send("{w down}")
Sleep(1000)  ; Increase from 500
Send("{w up}")
```

### Issue: Actions are detected as cheating

**Solution:** Add more randomization

```ahk
; More natural timing
RandomDelay(min, max) {
  return Random(min, max)
}

Loop {
  Send("{Mouse1}")
  Sleep(RandomDelay(800, 1200))  ; Not exactly 1000ms every time
}
```

## Server Compatibility

### Single-Player
✅ Fully compatible - use any settings

### Multiplayer (Vanilla)
⚠️ Check server rules - many servers ban AFK machines

### Multiplayer (Modded)
⚠️ Check for anti-cheat mods

### Realms
⚠️ May violate Microsoft ToS

## Best Practices

1. **Test in single-player** before using on servers
2. **Read server rules** about AFK automation
3. **Add randomization** to all timing
4. **Monitor your game** - don't leave completely unattended
5. **Respect the community** - don't ruin the game for others
6. **Use ethically** - some servers consider this cheating

## Resources

- [AutoHotkey v2 Documentation](https://www.autohotkey.com/docs/v2/)
- [Minecraft Wiki](https://minecraft.fandom.com/)
- [AFK Farm Designs](https://www.youtube.com/results?search_query=minecraft+afk+farm)
- [CLAUDE.md](../../CLAUDE.md) - Developer guide

## Contributing

When adding or modifying Minecraft macros:

1. Test in single-player extensively
2. Add comments for timing explanations
3. Include setup instructions
4. Add server compatibility notes
5. Implement safety features

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for detailed guidelines.

---

**Note:** Using AFK macros may violate some server rules or Minecraft's Terms of Service. Use responsibly and check your server's policies before using these scripts.

**Last Updated:** 2025-12-26
