#Requires AutoHotkey v2.0

; ============================================================================
; AFK_Hold_Click.ahk - Simple mouse button hold/release
; Version: 2.0.0 (Migrated to AHK v2)
;
; Hotkeys:
;   F6 - Hold left mouse button down
;   F7 - Release left mouse button and exit
; ============================================================================

#Include %A_ScriptDir%\..\..\Lib\v2\AHK_Common.ahk
InitScript(false, false, true)

#SingleInstance Force
ProcessSetPriority("High")

F6:: {
    Send("{LButton down}")
}

F7:: {
    Send("{LButton up}")
    ExitApp()
}
