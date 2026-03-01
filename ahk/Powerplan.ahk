#Requires AutoHotkey v2.0

; ============================================================================
; Powerplan.ahk - Auto power plan switcher based on process
; Version: 2.0.0 (Migrated to AHK v2)
;
; Functionality:
;   Switches to high performance when target process runs
;   Switches back to balanced when process closes
;
; Configuration:
;   Change the GUIDs below to match your system's power plans
;   Run "powercfg /list" in CMD to see your power plan GUIDs
; ============================================================================

#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
InitScript(false, false, true)

#SingleInstance Force
Persistent

; High Performance power plan GUID
cmdOnLaunch := "powercfg /s 8fcdad7d-7d71-4ea2-bb4c-158ca7f696de"

; Balanced power plan GUID
cmdOnClose := "powercfg /s 77777777-7777-7777-7777-777777777777"

; Track previous state
fortniteWasRunning := false

Loop {
    fortniteIsRunning := WinExist("ahk_exe FortniteClient-Win64-Shipping.exe")

    ; Only run command when state changes
    if (fortniteIsRunning && !fortniteWasRunning) {
        Run(cmdOnLaunch, , "Hide")
        fortniteWasRunning := true
    }
    else if (!fortniteIsRunning && fortniteWasRunning) {
        Run(cmdOnClose, , "Hide")
        fortniteWasRunning := false
    }

    DllCall("kernel32.dll\Sleep", "UInt", 5000)
}
