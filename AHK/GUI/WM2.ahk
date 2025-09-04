; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=53

if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}
RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run, "%A_ScriptName%", "C:\Program Files\AutoHotkey\AutoHotkey.exe" "%A_ScriptFullPath%"

if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}
RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run, "%A_ScriptName%"
