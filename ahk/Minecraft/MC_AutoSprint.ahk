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

; Autoclicker: hold Mouse Forward (XButton2) for ~10 right-clicks/sec.
; Click "right" sends down+up in one SendInput batch (0 ms hold) and Bedrock
; samples input per frame, so a zero-width click can be dropped between
; frames. Alternate the button state across ticks instead, giving each
; press/release a real hold duration.
XButton2:: SetTimer(AutoClickTick, 25)
XButton2 up:: {
  SetTimer(AutoClickTick, 0)
  Send "{Blind}{RButton up}"
}

AutoClickTick() {
  static down := false
  down := !down
  Send(down ? "{Blind}{RButton down}" : "{Blind}{RButton up}")
}
#HotIf
