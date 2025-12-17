#Include %A_ScriptDir%\..\..\Lib\AHK_Common.ahk
#Include %A_ScriptDir%\GUI_Shared.ahk
InitScript(true, true)  ; UIA + Admin required

EnvGet, oneDrivePath, OneDrive
if (oneDrivePath = "")
    oneDrivePath := A_MyDocuments

scriptsRoot := oneDrivePath . "\Backup\Optimal\Scripts\AHK"
gameRoot := oneDrivePath . "\Backup\Game\Steam"
keysPath := scriptsRoot . "\Keys.ahk"
hostPath := scriptsRoot . "\Script Master\Host.ahk"
autocorrectPath := scriptsRoot . "\Autocorrect.ahk"
gameboostPath := scriptsRoot . "\Gameboost.ahk"
battlefrontPath := gameRoot . "\Battlefront 2\FrostyModManager.lnk"

fortniteRoot := A_ProgramFiles
if (A_Is64bitOS)
    fortniteRoot := A_ProgramFiles64
fortnitePath := fortniteRoot . "\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe"

programFilesX86 := A_ProgramFiles
if (A_Is64bitOS && !InStr(programFilesX86, " (x86)"))
    programFilesX86 := A_ProgramFiles . " (x86)"
witcherPath := programFilesX86 . "\Steam\steamapps\common\The Witcher 3\bin\x64\witcher3.exe"

tabs := [{
    Name: "General",
    Buttons: [
        {Label: "Open Keys", Action: Func("OpenKeys")},
        {Label: "Close Keys", Action: Func("CloseKeys")},
        {Label: "Open Host", Action: Func("OpenHost")},
        {Label: "Close Host", Action: Func("CloseHost")},
        {Label: "Open Autocorrect", Action: Func("OpenAutocorrect")},
        {Label: "Close Autocorrect", Action: Func("CloseAutocorrect")}
    ]
}, {
    Name: "Games",
    Buttons: [
        {Label: "Open Fortnite", Action: Func("OpenFortnite")},
        {Label: "Close Fortnite", Action: Func("CloseFortnite")},
        {Label: "Open Battlefront", Action: Func("OpenBattlefront")},
        {Label: "Close Battlefront", Action: Func("CloseBattlefront")},
        {Label: "Open The Witcher 3", Action: Func("OpenWitcher")},
        {Label: "Close The Witcher 3", Action: Func("CloseWitcher")},
        {Label: "Open Gameboost", Action: Func("OpenGameboost")},
        {Label: "Close Gameboost", Action: Func("CloseGameboost")}
    ]
}]

CreateLauncher(tabs)
return

OpenKeys() {
    global KeysPID
    Run, %keysPath%,,, KeysPID
}

CloseKeys() {
    global KeysPID
    WinKill, ahk_pid %KeysPID%
}

OpenHost() {
    global HostPID
    Run, %hostPath%,,, HostPID
}

CloseHost() {
    global HostPID
    WinKill, ahk_pid %HostPID%
}

OpenAutocorrect() {
    global AutocorrectPID
    Run, %autocorrectPath%,,, AutocorrectPID
}

CloseAutocorrect() {
    global AutocorrectPID
    WinKill, ahk_pid %AutocorrectPID%
}

OpenFortnite() {
    global FortnitePID
    Run, %fortnitePath%,,, FortnitePID
    Process, Priority, %FortnitePID%, High
}

CloseFortnite() {
    global FortnitePID
    if (FortnitePID + 0)
        WinKill, ahk_pid %FortnitePID%
    else
        WinKill, FortniteClient-Win64-Shipping.exe
}

OpenBattlefront() {
    global BattlefrontPID
    Run, %battlefrontPath%
    WinWait, ahk_exe starwarsbattlefrontii.exe
    WinGet, BattlefrontPID, PID, ahk_exe starwarsbattlefrontii.exe
    Process, Priority, %BattlefrontPID%, High
}

CloseBattlefront() {
    global BattlefrontPID
    if (BattlefrontPID + 0)
        WinKill, ahk_pid %BattlefrontPID%
    else
        WinKill, starwarsbattlefrontii.exe
}

OpenWitcher() {
    global WitcherPID
    Run, %witcherPath%,,, WitcherPID
    Process, Priority, %WitcherPID%, High
}

CloseWitcher() {
    global WitcherPID
    if (WitcherPID + 0)
        WinKill, ahk_pid %WitcherPID%
    else
        WinKill, ahk_exe witcher3.exe
}

OpenGameboost() {
    global GamePID
    Run, %gameboostPath%,,, GamePID
}

CloseGameboost() {
    global GamePID
    WinKill, ahk_pid %GamePID%
}
