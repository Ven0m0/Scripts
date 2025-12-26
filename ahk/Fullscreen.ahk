#Requires AutoHotkey v2.0

; ============================================================================
; Fullscreen.ahk - Borderless fullscreen toggle with multi-monitor support
; Version: 2.0.0 (Migrated to AHK v2 and consolidated from 3 variants)
;
; Consolidates:
;   - Fullscreen.ahk (simple toggle)
;   - Fullscreen_single.ahk (double-tap detection)
;   - Fullscreen_double.ahk (separate enter/exit hotkeys)
;
; Hotkeys:
;   End                - Toggle borderless fullscreen (multi-monitor aware)
;   Ctrl+Alt+K         - Enter borderless fullscreen
;   Ctrl+Alt+L         - Exit and restore window
;   Ctrl+Alt+End       - Toggle with always-on-top
; ============================================================================

#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\v2\WindowManager.ahk

InitScript(true, true, true)  ; UIA + Admin + Performance optimizations
#SingleInstance Force
Persistent

; ============================================================================
; Primary hotkey - End key toggles fullscreen with multi-monitor support
; ============================================================================
End:: {
    ToggleFakeFullscreenMultiMonitor("A")
}

; ============================================================================
; Alternative hotkeys for explicit enter/exit
; ============================================================================

; Ctrl+Alt+K - Enter borderless fullscreen
^!k:: {
    WinSetAlwaysOnTop(1, "A")
    SetWindowBorderless("A")
    WinMove(0, 0, A_ScreenWidth, A_ScreenHeight, "A")
}

; Ctrl+Alt+L - Exit and restore window
^!l:: {
    WinSetAlwaysOnTop(0, "A")
    RestoreWindowBorders("A")
    WinMove(0, 0, 1280, 720, "A")
}

; Ctrl+Alt+End - Toggle with always-on-top (old single-tap behavior)
^!End:: {
    currentStyle := WinGetStyle("A")
    hasTitleBar := currentStyle & 0xC00000

    if (hasTitleBar) {
        ; Enter fullscreen
        WinSetAlwaysOnTop(1, "A")
        SetWindowBorderless("A")
        WinMove(0, 0, A_ScreenWidth, A_ScreenHeight, "A")
    } else {
        ; Exit fullscreen
        WinSetAlwaysOnTop(0, "A")
        RestoreWindowBorders("A")
        WinMove(0, 0, 1280, 720, "A")
    }
}
