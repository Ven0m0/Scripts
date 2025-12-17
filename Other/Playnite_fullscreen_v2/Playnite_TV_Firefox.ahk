#Requires AutoHotkey v2.0

; ============================================================================
; Playnite_TV_Firefox.ahk - Launch Playnite on TV with Firefox window management
; Version: 2.0.0 (Migrated to AHK v2)
;
; WARNING: Contains hardcoded paths that need customization
;   - Line 32: User-specific path (janni)
;   - Update paths before use
; ============================================================================

#Include %A_ScriptDir%\..\..\Lib\v2\AHK_Common.ahk
InitScript(false, false, true)

#SingleInstance Force

; Move cursor out of the way
DllCall("SetCursorPos", "int", 0, "int", 1080)

; Enable monitor 3 (TV)
RunWait(A_ScriptDir . "\MultiMonitorTool\MultiMonitorTool.exe /enable 3", , "hide")
DllCall("kernel32.dll\Sleep", "UInt", 250)

; Set TV as primary display
RunWait(A_ScriptDir . "\MultiMonitorTool\MultiMonitorTool.exe /SetPrimary 3", , "hide")
DllCall("kernel32.dll\Sleep", "UInt", 100)

; Move Firefox to TV (monitor 1)
RunWait(A_ScriptDir . '\MultiMonitorTool\MultiMonitorTool.exe /MoveWindow 1 Process "firefox.exe"', , "hide")

; Play boot video
vlcPath := "C:\Program Files\VideoLAN\VLC\vlc.exe"
bootVideo := A_ScriptDir . "\BootVideo.mp4"
vlcArgs := '--fullscreen --video-on-top --play-and-exit --no-video-title -Idummy "' . bootVideo . '"'
RunWait('cmd.exe /c START "" "' . vlcPath . '" ' . vlcArgs, , "hide")
DllCall("kernel32.dll\Sleep", "UInt", 3000)

; Launch Playnite
; TODO: Update these paths to match your system
playniteExe := EnvGet("USERPROFILE") . "\OneDrive\Backup\Game\Other\Launchers\Playnite\Playnite.FullscreenApp.exe"
playniteUser := A_UserName  ; Change this if needed

if (!FileExist(playniteExe)) {
    playniteExe := "C:\Program Files\Playnite\Playnite.FullscreenApp.exe"
}

playniteCmd := 'runas /noprofile /user:' . playniteUser . ' /savecred "' . playniteExe . ' --startfullscreen --hidesplashscreen"'
RunWait('cmd.exe /c ' . playniteCmd, , "hide")

; Activate Firefox first, then wait for Playnite
WinActivate("ahk_exe firefox.exe")
WinWait("ahk_exe Playnite.FullscreenApp.exe")
WinActivate("ahk_exe Playnite.FullscreenApp.exe")

; Monitor Playnite - when it closes, restore display settings
SetTimer(CheckPlaynite, 1000)

CheckPlaynite() {
    if (!WinExist("ahk_exe Playnite.FullscreenApp.exe")) {
        ; Restore primary display
        RunWait(A_ScriptDir . "\MultiMonitorTool\MultiMonitorTool.exe /SetPrimary 1", , "hide")
        DllCall("kernel32.dll\Sleep", "UInt", 100)

        ; Disable TV
        RunWait(A_ScriptDir . "\MultiMonitorTool\MultiMonitorTool.exe /disable 3", , "hide")

        ; Move Firefox back to monitor 2
        RunWait(A_ScriptDir . '\MultiMonitorTool\MultiMonitorTool.exe /MoveWindow 2 Process "firefox.exe"', , "hide")

        ExitApp()
    }
}
