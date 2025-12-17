#Requires AutoHotkey v2.0

; ============================================================================
; WM.ahk - Window Manager - Auto-save/restore window positions
; Version: 2.0.0 (Migrated to AHK v2)
;
; Original: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=53
;
; Functionality:
;   Automatically saves window size/position to INI file
;   Restores window size/position when window appears again
; ============================================================================

#SingleInstance Force
Persistent
SetWinDelay(50)
ProcessSetPriority("Normal")

MatchList := ""
ExclusionList := ["ShellExperienceHost.exe", "SearchUI.exe"]

; Build initial list of windows
try {
    idList := WinGetList(,, "Program Manager")
    for id in idList {
        if (MatchList == "")
            MatchList := id
        else
            MatchList .= "," . id
    }
}

; Main loop - monitor windows and save/restore positions
SetTimer(MonitorWindows, 350)

MonitorWindows() {
    global MatchList, ExclusionList

    try {
        active_id := WinGetID("A")
    } catch {
        return
    }

    ; Check if this is a new window
    if (!InStr(MatchList, active_id)) {
        ; New window detected
        MatchList .= "," . active_id

        try {
            active_ProcessName := WinGetProcessName("A")
            active_Class := WinGetClass("A")

            ; Try to restore saved position
            savedSizePos := IniRead(A_ScriptDir . "\WindowSizePosLog.ini", "Process Names", active_ProcessName, "ERROR")

            if (savedSizePos != "ERROR" && active_Class != "MultitaskingViewFrame" && active_Class != "Shell_TrayWnd") {
                ; Parse saved position
                OutputArray := StrSplit(savedSizePos, ",")

                if (active_ProcessName == "explorer.exe" && active_Class != "CabinetWClass") {
                    ; Skip explorer windows that aren't file explorers
                } else if (OutputArray.Length >= 4) {
                    WinMove(Integer(OutputArray[1]), Integer(OutputArray[2]), Integer(OutputArray[3]), Integer(OutputArray[4]), "A")
                }
            } else {
                ; No saved config - save current position
                SaveCurrentWindowPosition()
            }
        }
    } else {
        ; Existing window - update saved position
        SaveCurrentWindowPosition()
    }
}

SaveCurrentWindowPosition() {
    global ExclusionList

    try {
        WinGetPos(&X, &Y, &Width, &Height, "A")
        active_ProcessName := WinGetProcessName("A")
        active_Class := WinGetClass("A")

        ; Validate window dimensions
        if (X != "" && Y != "" && Width != "" && Height != "" && Width > 0 && Height > 0 &&
            active_Class != "MultitaskingViewFrame" && active_Class != "Shell_TrayWnd") {

            ; Check exclusions
            if (active_ProcessName == "explorer.exe" && active_Class != "CabinetWClass") {
                ; Skip explorer windows that aren't file explorers
                return
            }

            ; Check if in exclusion list
            for excludedProcess in ExclusionList {
                if (active_ProcessName == excludedProcess)
                    return
            }

            ; Save to INI
            IniWrite(X . "," . Y . "," . Width . "," . Height, A_ScriptDir . "\WindowSizePosLog.ini", "Process Names", active_ProcessName)
        }
    }
}
