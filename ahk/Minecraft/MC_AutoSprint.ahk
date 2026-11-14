#Requires AutoHotkey v2.0
#SingleInstance Force

#Include %A_ScriptDir%\..\..\Lib\AHK_Common.ahk
InitScript({titleMatch: 3})

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

; Autoclicker: hold the autoclick key (default Mouse Forward, XButton2) for ~10 right-clicks/sec.
; Click "right" sends down+up in one SendInput batch (0 ms hold) and Bedrock
; samples input per frame, so a zero-width click can be dropped between
; frames. Alternate the button state across ticks instead, giving each
; press/release a real hold duration.
; Binding comes from hotkeys.ini next to this script ([MC_AutoSprint]).
keys := LoadHotkeys(A_ScriptDir . "\hotkeys.ini", "MC_AutoSprint", Map("autoclick", "XButton2"))

StartAutoClick(*) {
    SetTimer(AutoClickTick, 25)
}

StopAutoClick(*) {
    SetTimer(AutoClickTick, 0)
    Send "{Blind}{RButton up}"
}

AutoClickTick() {
    static down := false
    down := !down
    Send(down ? "{Blind}{RButton down}" : "{Blind}{RButton up}")
}

HotIfWinActive("ahk_exe Minecraft.Windows.exe")
Hotkey(keys["autoclick"], StartAutoClick)
Hotkey(keys["autoclick"] . " up", StopAutoClick)
HotIfWinActive()
