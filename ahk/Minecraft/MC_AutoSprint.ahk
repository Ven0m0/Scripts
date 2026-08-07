#Requires AutoHotkey v2.0
#SingleInstance Force
ListLines False
SendMode "Input"
SetKeyDelay(-1, -1)
SetControlDelay(-1)
SetTitleMatchMode(3)
SetTitleMatchMode("Fast")

; Bedrock sprint bind is Ctrl. Hold W -> W + Ctrl held together, both released on W up.
; Ctrl+key in Bedrock. Harmless for default binds; if it misfires, switch to a single
; Send "{Blind}{LControl}" tap on w down instead of down/up around KeyWait.
#HotIf WinActive("ahk_exe Minecraft.Windows.exe")
*w:: {
  Send "{Blind}{w down}{LControl down}"
  KeyWait "w"
  Send "{Blind}{LControl up}{w up}"
}
#HotIf
