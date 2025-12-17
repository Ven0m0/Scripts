#Requires AutoHotkey v2.0

; ============================================================================
; AFK_Bank_Roof_Always.ahk - Continuous AFK macro for Bank Roof
; Version: 2.0.0 (Migrated to AHK v2)
;
; Hotkeys:
;   F6 - Start continuous shooting
;   F7 - Stop and exit
; ============================================================================

#Include %A_ScriptDir%\..\..\Lib\v2\AHK_Common.ahk
InitScript(false, false, true)

#SingleInstance Force
ProcessSetPriority("High")

AFK() {
    rand := Random(0, 20)
    DllCall("Sleep", "UInt", rand)
    Send("{LButton}")
    Sleep(10)
    Send("{g}")
}

F6:: {
    SetTimer(AFK, 100)
}

F7:: {
    ExitApp()
}
