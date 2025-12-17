; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=53

; Automatically Restore Previous Window Size/Pos

; To make this script run when windows starts, make sure RegistryAdd.ahk is in the same directory as this script, run this script, and it will be added to the registry. Then delete RegistryAdd.ahk
#Include *i RegistryAdd.ahk

; To easily remove the previously added registry entry, make sure RegistryRemove.ahk is in the same directory as this script, run this script, and it will be removed from the registry. Then delete RegistryRemove.ahk
#Include *i RegistryRemove.ahk

#SingleInstance Force
#Persistent
#NoEnv
;#NoTrayIcon
SetWinDelay, 50
Process, Priority, , Normal

MatchList := ""

; Build the MatchList
WinGet, id, list,,, Program Manager
Loop, %id%
{
    this_id := id%A_Index%
    if (MatchList = "")
    MatchList := this_id
    else
    MatchList := MatchList . "," . this_id 
}

; ExclusionList
ExclusionList = ShellExperienceHost.exe,SearchUI.exe

; The main program loop, which manages window positions/sizes and saves their last known configuration to an ini file in the script directory.
Loop,
{
    Sleep, 350
    WinGet, active_id, ID, A
    if active_id not in %MatchList% ; Then this is a new window ID! So, check if it has a configuration saved.
    {
        MatchList := MatchList . "," . active_id ; This window ID is not new anymore!
        WinGet, active_ProcessName, ProcessName, A
        WinGetClass, active_Class, A
        IniRead, savedSizePos, %A_ScriptDir%\WindowSizePosLog.ini, Process Names, %active_ProcessName%
        if (savedSizePos != "ERROR" AND active_Class != "MultitaskingViewFrame" AND active_class != "Shell_TrayWnd") ; Then a saved configuration exists, size/move the window!
        {
            StringSplit OutputArray, savedSizePos,`,
            if (active_ProcessName = "explorer.exe" AND active_Class != "CabinetWClass")
            {
                
            }
            else
            {
                WinMove, A,, OutputArray1, OutputArray2, OutputArray3, OutputArray4
            }
        }
        else ; No saved configuration exists, save the current window size/pos as a configuration instead!
        {
            WinGetPos X, Y, Width, Height, A
            WinGet, active_ProcessName, ProcessName, A
            WinGetClass, active_Class, A
            If (X != "" AND Y != "" AND Width != "" AND Height != "" AND Width > 0 AND Height > 0 AND active_Class != "MultitaskingViewFrame" AND active_class != "Shell_TrayWnd")
            {
                if (active_ProcessName = "explorer.exe" AND active_Class != "CabinetWClass")
                {
                    
                }
                else if active_ProcessName not in %ExclusionList%
                {
                    IniWrite %X%`,%Y%`,%Width%`,%Height%, %A_ScriptDir%\WindowSizePosLog.ini, Process Names, %active_ProcessName%
                }
            }
        }
    }
    else ; Save/overwrite the active window size and position to a file with a link to the processname, for later use.
    {
        WinGetPos X, Y, Width, Height, A
        WinGet, active_ProcessName, ProcessName, A
        WinGetClass, active_Class, A
        If (X != "" AND Y != "" AND Width != "" AND Height != "" AND Width > 0 AND Height > 0 AND active_Class != "MultitaskingViewFrame" AND active_class != "Shell_TrayWnd")
        {
            if (active_ProcessName = "explorer.exe" AND active_Class != "CabinetWClass")
            {
                
            }
            else if active_ProcessName not in %ExclusionList%
            {
                IniWrite %X%`,%Y%`,%Width%`,%Height%, %A_ScriptDir%\WindowSizePosLog.ini, Process Names, %active_ProcessName%
            }
        }
    }
}
Return
