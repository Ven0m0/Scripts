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
    ; Optimization: Read the entire section once to reduce disk I/O
    sectionContent := IniRead(configFile, emulatorName)
    config := Map()
    config.CaseSense := "Off" ; Ensure case-insensitive lookups (INI standard)
    Loop Parse, sectionContent, "`n", "`r" {
        if (p := InStr(A_LoopField, "=")) {
            k := Trim(SubStr(A_LoopField, 1, p-1))
            v := Trim(SubStr(A_LoopField, p+1))
            config[k] := v
        }
    }

    if !config.Has("exe") {
        if (config.Count = 0)
            throw Error("Section '" . emulatorName . "' is empty or missing required key 'exe'")
        else
            throw Error("Key 'exe' not found in section '" . emulatorName . "'")
    }

    exeName := config["exe"]
    key := config.Has("key") ? config["key"] : "F11"
    maximize := (config.Has("maximize") ? config["maximize"] : "true") = "true"
    if config.Has("delay") {
        delayRaw := config["delay"]
        if RegExMatch(delayRaw, "^[+-]?\d+$") {
            delay := Integer(delayRaw)
        } else {
            throw Error("Invalid delay value '" . delayRaw . "' in section '" . emulatorName . "': must be an integer number of milliseconds")
        }
    } else {
        delay := 0
    }
    activate := (config.Has("activate") ? config["activate"] : "false") = "true"
    special := config.Has("special") ? config["special"] : "none"

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
