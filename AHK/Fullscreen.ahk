#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\WindowManager.ahk

InitScript(true, true)  ; UIA + Admin required

#NoEnv
SetBatchLines -1
SetControlDelay -1
#SingleInstance Force
#persistent
#Warn

; End key toggles fullscreen with multi-monitor support
End::ToggleFakeFullscreenMultiMonitor()
