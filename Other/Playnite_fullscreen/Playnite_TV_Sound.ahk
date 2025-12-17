#Include %A_ScriptDir%\..\..\Lib\v1\AHK_Common.ahk
InitScript()

#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 3
SetTitleMatchMode, Fast


DllCall("SetCursorPos", "int", 0, "int", 1080)
RunWait, %A_ScriptDir%\MultiMonitorTool\MultiMonitorTool.exe /enable 3,, hide
RunWait, %A_ScriptDir%\MultiMonitorTool\MultiMonitorTool.exe /SetPrimary 3,, hide ; Make TV main Display
RunWait, %A_ScriptDir%\SoundVolumeView\SoundVolumeView.exe /SetDefault NVIDIA High Definition Audio
RunWait, cmd.exe /c START "" "C:\Program Files\VideoLAN\VLC\vlc.exe" --fullscreen --video-on-top --play-and-exit --no-video-title -Idummy "%A_ScriptDir%\BootVideo.mp4",,hide ; Start PS5 boot Video
DllCall("kernel32.dll\Sleep", "UInt", 3000)
RunWait, cmd.exe /c runas /noprofile /user:janni /savecred "C:\Users\janni\OneDrive\Backup\Game\Other\Launchers\Playnite\Playnite.FullscreenApp.exe --startfullscreen --hidesplashscreen",,hide
WinActivate, ahk_exe msedge.exe
WinWait, ahk_exe Playnite.FullscreenApp.exe
WinActivate, ahk_exe Playnite.FullscreenApp.exe

SetTimer, Playnite, 1000
Exit

Playnite(){
    if !WinExist("ahk_exe Playnite.FullscreenApp.exe") {
        RunWait, %A_ScriptDir%\MultiMonitorTool\MultiMonitorTool.exe /SetPrimary 1,, hide ; Make Default Monitor main Display again
        RunWait, %A_ScriptDir%\SoundVolumeView\SoundVolumeView.exe /SetDefault THX Spatial - Synapse
        RunWait, %A_ScriptDir%\MultiMonitorTool\MultiMonitorTool.exe /disable 3,, hide
        ExitApp
    }
}