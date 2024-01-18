; UIA check
if (!InStr(A_AhkPath, "_UIA.exe")) {
	newPath := RegExReplace(A_AhkPath, "\.exe", "U" (32 << A_Is64bitOS) "_UIA.exe")
	Run % StrReplace(DllCall("Kernel32\GetCommandLine", "Str"), A_AhkPath, newPath)
	ExitApp
}
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

$*F7::
Loop{
Click, down, right
Sleep 100
Click, up, right
Sleep 9500
Click, down, right
Sleep 100
Click, up, right
}




$*F8::
Pause
Return

$*F9::
ExitApp
Return
