 if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}
#NoEnv
SetBatchLines -1
SetControlDelay -1
ListLines Off
#SingleInstance Force
#persistent
#Warn

End::
{
KeyWait, End
KeyWait, End, D T.2
If (!ErrorLevel)
{
goto, double
}
Else
goto, single
}
return

single:
{
WinSet, AlwaysOnTop, On, A ; Focus
WinSet, Style, -0xC00000, A ; hide title bar
WinSet, Style, -0x800000, A ; hide thin-line border
WinSet, Style, -0x400000, A ; hide dialog frame
WinSet, Style, -0x40000, A ; hide thickframe/sizebox
WinMove, A, , 0, 0, A_ScreenWidth, A_ScreenHeight
}
return

double:
{
WinSet, AlwaysOnTop, Off, A ; Focus
WinSet, Style, +0xC00000, A ; show title bar
WinSet, Style, +0x800000, A ; show thin-line border
WinSet, Style, +0x400000, A ; show dialog frame
WinSet, Style, +0x40000, A ; show thickframe/sizebox
WinMove, A, , 0, 0, 1280, 720
}
return