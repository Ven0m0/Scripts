#Requires AutoHotkey v2.0

; ============================================================================
; Playnite_All.ahk - Unified launcher for Playnite fullscreen modes
; Modes:
;   fullscreen   - Boot video + Playnite (no monitor/audio changes)
;   tv           - TV as primary, boot video, Playnite
;   tv_firefox   - TV primary, move Firefox to TV, boot video, Playnite
;   tv_sound     - TV primary, switch audio to TV, boot video, Playnite
; ============================================================================

#Include %A_ScriptDir%\..\..\Lib\v2\AHK_Common.ahk
InitScript(false, false, true)

#SingleInstance Force

FindExe(name, fallbacks := []) {
    if FileExist(name)
        return name
    Loop Parse, EnvGet("PATH"), ";"
    {
        p := Trim(A_LoopField)
        if !p
            continue
        cand := p . "\" . name
        if FileExist(cand)
            return cand
    }
    for _, fb in fallbacks
        if FileExist(fb)
            return fb
    return ""
}

MustGetExe(name, fallbacks := []) {
    exe := FindExe(name, fallbacks)
    if exe = ""
    {
        MsgBox("Required executable not found: " . name . "`nChecked PATH and fallbacks.")
        ExitApp(1)
    }
    return exe
}

ShowHelp() {
    MsgBox("Usage:`n  " . A_ScriptName . " <mode>`n`nModes:`n  fullscreen`n  tv`n  tv_firefox`n  tv_sound")
    ExitApp(1)
}

PlayBootVideo() {
    vlcPath := MustGetExe("vlc.exe", ["C:\Program Files\VideoLAN\VLC\vlc.exe"])
    bootVideo := A_ScriptDir . "\BootVideo.mp4"
    vlcArgs := '--fullscreen --video-on-top --play-and-exit --no-video-title -Idummy "' . bootVideo . '"'
    RunWait('cmd.exe /c START "" "' . vlcPath . '" ' . vlcArgs, , "hide")
    DllCall("kernel32.dll\Sleep", "UInt", 3000)
}

LaunchPlaynite() {
    playniteExe := MustGetExe(
        "Playnite.FullscreenApp.exe",
        [EnvGet("USERPROFILE") . "\OneDrive\Backup\Game\Other\Launchers\Playnite\Playnite.FullscreenApp.exe"
        , "C:\Program Files\Playnite\Playnite.FullscreenApp.exe"]
    )
    playniteUser := A_UserName  ; Adjust if needed
    playniteCmd := 'runas /noprofile /user:' . playniteUser . ' /savecred "' . playniteExe . ' --startfullscreen --hidesplashscreen"'
    RunWait('cmd.exe /c ' . playniteCmd, , "hide")
}

global mode := ""
global mmtool := ""
global svv := ""

if (A_Args.Length < 1)
    ShowHelp()

mode := StrLower(A_Args[1])

; Common: move cursor away
DllCall("SetCursorPos", "int", 0, "int", 1080)

if (mode = "fullscreen") {
    PlayBootVideo()
    LaunchPlaynite()
    WinWait("ahk_exe Playnite.FullscreenApp.exe")
    WinActivate("ahk_exe Playnite.FullscreenApp.exe")
} else if (mode = "tv" or mode = "tv_firefox" or mode = "tv_sound") {
    mmtool := MustGetExe("MultiMonitorTool.exe", [A_ScriptDir . "\MultiMonitorTool\MultiMonitorTool.exe"])
    if (mode = "tv_sound")
        svv := MustGetExe("SoundVolumeView.exe", [A_ScriptDir . "\SoundVolumeView\SoundVolumeView.exe"])

    RunWait(mmtool . " /enable 3", , "hide")
    DllCall("kernel32.dll\Sleep", "UInt", 250)
    RunWait(mmtool . " /SetPrimary 3", , "hide")
    DllCall("kernel32.dll\Sleep", "UInt", 100)

    if (mode = "tv_firefox")
        RunWait(mmtool . ' /MoveWindow 1 Process "firefox.exe"', , "hide")

    if (mode = "tv_sound")
        RunWait(svv . ' /SetDefault "NVIDIA High Definition Audio"', , "hide") ; Update device name as needed

    PlayBootVideo()
    LaunchPlaynite()

    if (mode = "tv_firefox")
        WinActivate("ahk_exe firefox.exe")
    else if (mode = "tv_sound")
        WinActivate("ahk_exe msedge.exe")

    WinWait("ahk_exe Playnite.FullscreenApp.exe")
    WinActivate("ahk_exe Playnite.FullscreenApp.exe")
} else {
    ShowHelp()
}

SetTimer(CheckPlaynite, 1000)

CheckPlaynite() {
    global mode, mmtool, svv
    if (WinExist("ahk_exe Playnite.FullscreenApp.exe"))
        return
    if (mode = "tv" or mode = "tv_firefox" or mode = "tv_sound") {
        RunWait(mmtool . " /SetPrimary 1", , "hide")
        DllCall("kernel32.dll\Sleep", "UInt", 100)
        if (mode = "tv_firefox")
            RunWait(mmtool . ' /MoveWindow 2 Process "firefox.exe"', , "hide")
        if (mode = "tv_sound")
            RunWait(svv . ' /SetDefault "THX Spatial - Synapse"', , "hide") ; Update device name as needed
        RunWait(mmtool . " /disable 3", , "hide")
    }
    ExitApp()
}
