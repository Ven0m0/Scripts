#Requires AutoHotkey v2.0

; ============================================================================
; MC_AFK_Fishing.ahk - Minecraft AFK fishing macro
; Version: 2.0.0 (Migrated to AHK v2)
;
; Hotkeys:
;   F7 - Start fishing loop
;   F8 - Pause/Resume
;   F9 - Exit
; ============================================================================

#Include %A_ScriptDir%\..\..\Lib\v2\AHK_Common.ahk
InitScript(false, false, true)

#SingleInstance Force

F7:: {
    Loop {
        Click("down", "right")
        Sleep(100)
        Click("up", "right")
        Sleep(9500)
        Click("down", "right")
        Sleep(100)
        Click("up", "right")
    }
}

F8:: {
    Pause(-1)
}

F9:: {
    ExitApp()
}
