#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force

if JoystickNumber <= 0
{
	Loop 16  ; Query each joystick number to find out which ones exist.
	{
		GetKeyState, JoyName, %A_Index%JoyName
		if JoyName <>
		{
			JoystickNumber = %A_Index%
			break
		}
	}
	if JoystickNumber <= 0
	{
		ExitApp
	}
}


GetKeyState, joy_buttons, %JoystickNumber%JoyButtons
Loop
{
    ;Get pressed controller buttons, regardless of controller index
	buttons_down =
	Loop, %joy_buttons%
	{
		GetKeyState, joy%A_Index%, %JoystickNumber%joy%A_Index%
		if joy%A_Index% = D
			buttons_down = %buttons_down%%A_Space%%A_Index%
	}

    ;If Joy7 (Select) and Joy8 (Start) is pressed, close the active window.
    if InStr(buttons_down, 9) && InStr(buttons_down, 10)
    {
		#IfWinNotActive ahk_class WorkerW
        WinClose, A
		#IfWinNotActive
    }
	Sleep, 200
}
return