; UIA check
if (!InStr(A_AhkPath, "_UIA.exe")) {
	newPath := RegExReplace(A_AhkPath, "\.exe", "U" (32 << A_Is64bitOS) "_UIA.exe")
	Run % StrReplace(DllCall("Kernel32\GetCommandLine", "Str"), A_AhkPath, newPath)
	ExitApp
}

#SingleInstance Force
#Warn  ; Enable warnings to assist with detecting common errors.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 3 ; Use SetTitleMatchMode 2 when you want to use wintitle that contains text anywhere in the title
SetTitleMatchMode, Fast


; Replace "YourCommandOnLaunch" with the command you want to execute on launch
cmdOnLaunch := "powercfg /s 8fcdad7d-7d71-4ea2-bb4c-158ca7f696de"

; Replace "YourCommandOnClose" with the command you want to execute on close
cmdOnClose := "powercfg /s 77777777-7777-7777-7777-777777777777"

Loop
{
if WinExist("ahk_exe FortniteClient-Win64-Shipping.exe")
    Run, %comspec% /c %cmdOnLaunch%, , Hide
if not WinExist("ahk_exe FortniteClient-Win64-Shipping.exe")
    Run, %comspec% /c %cmdOnClose%, , Hide
DllCall("kernel32.dll\Sleep", "UInt", 5000)
}