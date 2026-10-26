#Requires AutoHotkey v2.0

; ============================================================================
; Fullscreen.ahk - Fake fullscreen toggle on the active window's own monitor
;
; Hotkeys:
;   End                - Toggle fake fullscreen
;   Ctrl+Alt+End       - Toggle fake fullscreen, always-on-top while fullscreen
; ============================================================================

#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\WindowManager.ahk

InitScript(true, true)  ; Admin + Performance optimizations
Persistent

End::ToggleFakeFullscreen()

^!End:: {
    isFullscreen := ToggleFakeFullscreen()
    try WinSetAlwaysOnTop(isFullscreen, "A")  ; no active window: nothing to pin
}
