#Requires AutoHotkey v2.0

; ============================================================================
; AutoStartManager.ahk - Unified auto-fullscreen launcher for emulators
; Version: 2.0.0
;
; Usage: AutoStartManager.ahk EmulatorName
; Example: AutoStartManager.ahk Citra
;
; Consolidates 9 individual auto-start scripts into one data-driven solution
; Configuration is stored in AutoStartConfig.ini
; ============================================================================

#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\v2\AutoStartHelper.ahk
#SingleInstance Force

; Initialize script
InitScript(true, false, true)

; Get emulator name from command line
if (A_Args.Length == 0) {
    MsgBox("Usage: AutoStartManager.ahk EmulatorName`n`nExample: AutoStartManager.ahk Citra")
    ExitApp()
}

emulatorName := A_Args[1]
configFile := A_ScriptDir . "\AutoStartConfig.ini"

; Check if config file exists
if (!FileExist(configFile)) {
    MsgBox("Config file not found: " . configFile)
    ExitApp()
}

; Read configuration
try {
    exeName := IniRead(configFile, emulatorName, "exe")
    key := IniRead(configFile, emulatorName, "key", "F11")
    maximize := IniRead(configFile, emulatorName, "maximize", "true") = "true"
    delay := Integer(IniRead(configFile, emulatorName, "delay", "0"))
    activate := IniRead(configFile, emulatorName, "activate", "false") = "true"
    special := IniRead(configFile, emulatorName, "special", "none")
} catch Error as err {
    MsgBox("Error reading config for " . emulatorName . ":`n" . err.Message)
    ExitApp()
}

; Handle special cases
if (special = "melon_f11") {
    ; MelonDS requires special F11 handling (down/up)
    WinWait("ahk_exe " . exeName)
    Sleep(delay)
    WinActivate("ahk_exe " . exeName)
    if (maximize)
        WinMaximize("ahk_exe " . exeName)
    SendInput("{F11 down}")
    Sleep(100)
    SendInput("{F11 up}")
    ExitApp()
}

; Standard auto-fullscreen handling
AutoStartFullscreen(exeName, key, maximize, delay, activate)
ExitApp()
