#Requires AutoHotkey v2.0

; ============================================================================
; MC_AFK_Mob.ahk - Minecraft AFK mob farm with auto-eating
; Version: 2.0.0 (Migrated to AHK v2)
;
; Hotkeys:
;   F7 - Start macro (switches to slot 1 and sets eat timer)
;   F8 - Pause/Resume
;   F9 - Exit
; ============================================================================

#Include %A_ScriptDir%\..\..\Lib\v2\AHK_Common.ahk
InitScript(false, false, true)

#SingleInstance Force

eatFood() {
    Sleep(150)  ; Wait for sword swing to finish if in progress
    Send("6")  ; Switch to food slot
    Sleep(200)
    Click("down", "right")
    Sleep(3500)  ; Wait until food eaten
    Click("up", "right")
    Sleep(200)
    Send("1")  ; Switch back to sword
    Sleep(200)
}

F7:: {
    Send("1")  ; Switch to slot 1 (sword)
    SetTimer(eatFood, 60000)  ; Eat every 60 seconds
}

F8:: {
    Pause(-1)
}

F9:: {
    ExitApp()
}
