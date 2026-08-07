#Requires AutoHotkey v2.0

; ============================================================================
; Auto_start_Spider-Man.ahk - Auto-start Spider-Man with splash screen dismiss
; ============================================================================

#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
InitScript(false, false, true)

; Run unified AutoStartManager for SpiderMan
Run('"' . A_AhkPath . '" "' . A_ScriptDir . '\AutoStartManager.ahk" SpiderMan')
ExitApp()
