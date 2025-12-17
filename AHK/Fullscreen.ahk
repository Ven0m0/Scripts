#Include %A_ScriptDir%\..\Lib\v1\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\v1\WindowManager.ahk

InitScript(true, true)  ; UIA + Admin required

#NoEnv
SetBatchLines -1
SetControlDelay -1
#SingleInstance Force
#persistent
#Warn

; End key toggles fullscreen with multi-monitor support
End::ToggleFakeFullscreenMultiMonitor()
