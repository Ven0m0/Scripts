#Requires AutoHotkey v2.0

; ============================================================================
; Lossless_Scaling_start.ahk - Start and minimize Lossless Scaling
; Version: 2.0.0 (Migrated to AHK v2)
;
; WARNING: Contains hardcoded path that needs customization
;   Original: C:\Users\janni\OneDrive\...
;   Update the path below to match your installation
; ============================================================================

#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
InitScript(false, false, true)

#SingleInstance Force
DetectHiddenText(false)
DetectHiddenWindows(false)

; TODO: Update this path to your Lossless Scaling installation
; Original: C:\Users\janni\OneDrive\Backup\Game\Other\Tools\FSR\Lossless Scaling\LosslessScaling.exe
LSPath := "C:\Program Files\Lossless Scaling\LosslessScaling.exe"

try {
    RunWait(LSPath)
    DllCall("kernel32.dll\Sleep", "UInt", 800)
    WinMinimize("ahk_exe LosslessScaling.exe")
} catch Error as err {
    MsgBox("Failed to start Lossless Scaling:`n" . err.Message . "`n`nUpdate the path in the script.")
}
