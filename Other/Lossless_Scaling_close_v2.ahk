#Requires AutoHotkey v2.0

; ============================================================================
; Lossless_Scaling_close.ahk - Close Lossless Scaling process
; Version: 2.0.0 (Migrated to AHK v2)
; ============================================================================

#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
InitScript(false, true, true)  ; Requires admin

#SingleInstance Force

try {
    ProcessClose("LosslessScaling.exe")
} catch Error as err {
    ; Process not found or already closed
}
