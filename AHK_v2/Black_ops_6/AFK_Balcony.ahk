#Requires AutoHotkey v2.0

; ============================================================================
; AFK_Balcony.ahk - AFK macro for Black Ops 6 Balcony strategy
; Version: 2.0.0 (Migrated to AHK v2)
;
; Hotkeys:
;   F6 - Start AFK macro
;   F7 - Stop macro and exit
; ============================================================================

#Include %A_ScriptDir%\..\..\Lib\v2\AHK_Common.ahk
InitScript(false, false, true)

#SingleInstance Force
ProcessSetPriority("High")

F6:: {
    SetTimer(AFK, 500)
}

AFK() {
    rand := Random(250, 2001)
    Sleep(rand)
    Send("{p}")
    Sleep(1001)
    Send("{2}")
    Sleep(1001)
    Send("{RButton down}")
    Sleep(1001)
    Send("{RButton up}")
    Sleep(3001)
    Send("{c}")
    Sleep(1001)
    Send("{p}")
    Sleep(75001)
}

F7:: {
    SetTimer(AFK, 0)
    ExitApp()
}
