#Requires AutoHotkey v2.0

; ============================================================================
; Playnite_TV_Sound.ahk - Launch Playnite on TV with audio device switching
; Version: 2.0.0 (Migrated to AHK v2)
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

mmtool := MustGetExe("MultiMonitorTool.exe", [A_ScriptDir . "\MultiMonitorTool\MultiMonitorTool.exe"])
svv    := MustGetExe("SoundVolumeView.exe", [A_ScriptDir . "\SoundVolumeView\SoundVolumeView.exe"])

; Move cursor out of the way
DllCall("SetCursorPos", "int", 0, "int", 1080)

; Enable monitor 3 (TV)
RunWait(mmtool . " /enable 3", , "hide")
DllCall("kernel32.dll\Sleep", "UInt", 250)

; Set TV as primary display
RunWait(mmtool . " /SetPrimary 3", , "hide")
DllCall("kernel32.dll\Sleep", "UInt", 100)

; Switch audio output to TV
RunWait(svv . ' /SetDefault "NVIDIA High Definition Audio"', , "hide")

; Play boot video
vlcPath := MustGetExe("vlc.exe", ["C:\Program Files\VideoLAN\VLC\vlc.exe"])
bootVideo := A_ScriptDir . "\BootVideo.mp4"
vlcArgs := '--fullscreen --video-on-top --play-and-exit --no-video-title -Idummy "' . bootVideo . '"'
RunWait('cmd.exe /c START "" "' . vlcPath . '" ' . vlcArgs, , "hide")
DllCall("kernel32.dll\Sleep", "UInt", 3000)

; Launch Playnite
playniteExe := MustGetExe(
    "Playnite.FullscreenApp.exe",
    [EnvGet("USERPROFILE") . "\OneDrive\Backup\Game\Other\Launchers\Playnite\Playnite.FullscreenApp.exe"
    , "C:\Program Files\Playnite\Playnite.FullscreenApp.exe"]
)
playniteUser := A_UserName  ; Change this if needed
playniteCmd := 'runas /noprofile /user:' . playniteUser . ' /savecred "' . playniteExe . ' --startfullscreen --hidesplashscreen"'
RunWait('cmd.exe /c ' . playniteCmd, , "hide")

; Activate Edge first, then wait for Playnite
WinActivate("ahk_exe msedge.exe")
WinWait("ahk_exe Playnite.FullscreenApp.exe")
WinActivate("ahk_exe Playnite.FullscreenApp.exe")

; Monitor Playnite - when it closes, restore display and audio settings
SetTimer(CheckPlaynite, 1000)

CheckPlaynite() {
    if (!WinExist("ahk_exe Playnite.FullscreenApp.exe")) {
        mmtool := MustGetExe("MultiMonitorTool.exe", [A_ScriptDir . "\MultiMonitorTool\MultiMonitorTool.exe"])
        svv    := MustGetExe("SoundVolumeView.exe", [A_ScriptDir . "\SoundVolumeView\SoundVolumeView.exe"])
        RunWait(mmtool . " /SetPrimary 1", , "hide")
        DllCall("kernel32.dll\Sleep", "UInt", 100)
        RunWait(svv . ' /SetDefault "THX Spatial - Synapse"', , "hide")
        RunWait(mmtool . " /disable 3", , "hide")
        ExitApp()
    }
}
