#Include %A_ScriptDir%\..\..\Lib\v1\AHK_Common.ahk
InitScript()

#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 3
SetTitleMatchMode, Fast

DllCall("SetCursorPos", "int", 0, "int", 1080)
RunWait, cmd.exe /c START "" "C:\Program Files\VideoLAN\VLC\vlc.exe" --fullscreen --video-on-top --play-and-exit --no-video-title -Idummy "%A_ScriptDir%\BootVideo.mp4",,hide
DllCall("kernel32.dll\Sleep", "UInt", 3000)
RunWait, cmd.exe /c runas /noprofile /user:janni /savecred "C:\Users\janni\OneDrive\Backup\Game\Other\Launchers\Playnite\Playnite.FullscreenApp.exe --startfullscreen --hidesplashscreen",,hide
WinWait, ahk_exe Playnite.FullscreenApp.exe
WinActivate, ahk_exe Playnite.FullscreenApp.exe
#IfWinNotExist ahk_exe Playnite.FullscreenApp.exe
ExitApp