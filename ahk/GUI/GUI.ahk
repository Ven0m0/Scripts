#Requires AutoHotkey v2.0

; ============================================================================
; GUI_All.ahk - Unified launcher combining laptop + PC buttons
; Tabs:
;   Laptop General, Laptop Games, PC General, PC Games, PC Utilities
; Paths are examples; update to your environment.
; ============================================================================

#Include %A_ScriptDir%\GUI_Shared.ahk

; Resolve user root
userRoot := EnvGet("USERPROFILE")
if (!userRoot)
    userRoot := "C:\Users\" . A_UserName

; Laptop paths (edit to match your layout)
laptopScriptsRoot := userRoot . "\Documents\Scripts\"

; PC paths (edit to match your layout)
pcScriptsRoot := userRoot . "\OneDrive\Backup\Optimal\Scripts\AHK\"
pcGameRoot    := userRoot . "\OneDrive\Backup\Game\Steam\"
fortniteExe   := "C:\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe"
witcherExe    := "C:\Program Files (x86)\Steam\steamapps\common\The Witcher 3\bin\x64\witcher3.exe"

tabs := "Laptop General|Laptop Games|PC General|PC Games|PC Utilities"

; Laptop General
laptopGeneral := [
    Map("label", "Open Keys",  "x", 22,  "y", 34,  "action", Map("run", laptopScriptsRoot . "Keys.ahk", "storePidVar", "KeysPID")),
    Map("label", "Close Keys", "x", 105, "y", 34,  "action", Map("killPidVar", "KeysPID")),
    Map("label", "Open Host",  "x", 22,  "y", 90,  "action", Map("run", laptopScriptsRoot . "Script Master\Host.ahk", "storePidVar", "HostPID")),
    Map("label", "Close Host", "x", 105, "y", 90,  "action", Map("killPidVar", "HostPID"))
]

; Laptop Games
laptopGames := [
    Map("label", "Open ShellShockLive",  "x", 22,  "y", 34,  "action", Map("run", "C:\Program Files (x86)\Steam\steamapps\common\ShellShock Live\ShellShockLive.exe")),
    Map("label", "Close ShellShockLive", "x", 105, "y", 34,  "action", Map("killWinTitle", "ahk_exe ShellShockLive.exe")),
    Map("label", "Open Robosquare",      "x", 22,  "y", 90,  "action", Map("run", "C:\Program Files (x86)\Steam\steamapps\common\RoboSquare\RoboSquare.exe")),
    Map("label", "Close Robosquare",     "x", 105, "y", 90,  "action", Map("killWinTitle", "ahk_exe RoboSquare.exe")),
    Map("label", "Open Y8 Games",        "x", 22,  "y", 146, "action", Map("run", "https://y8.com")),
    Map("label", "Close Y8 Games",       "x", 105, "y", 146, "action", Map("activateTitle", "Y8 Games", "sendKeys", "^w"))
]

; PC General
pcGeneral := [
    Map("label", "Open Keys",        "x", 22,  "y", 34,  "action", Map("run", pcScriptsRoot . "Keys.ahk", "storePidVar", "KeysPID")),
    Map("label", "Close Keys",       "x", 105, "y", 34,  "action", Map("killPidVar", "KeysPID")),
    Map("label", "Open Host",        "x", 22,  "y", 90,  "action", Map("run", pcScriptsRoot . "Script Master\Host.ahk", "storePidVar", "HostPID")),
    Map("label", "Close Host",       "x", 105, "y", 90,  "action", Map("killPidVar", "HostPID")),
    Map("label", "Open Autocorrect", "x", 22,  "y", 146, "action", Map("run", pcScriptsRoot . "Autocorrect.ahk", "storePidVar", "AutocorrectPID")),
    Map("label", "Close Autocorrect","x", 105, "y", 146, "action", Map("killPidVar", "AutocorrectPID"))
]

; PC Games
pcGames := [
    Map("label", "Open Fortnite",    "x", 22,  "y", 34,  "action", Map("run", fortniteExe, "storePidVar", "FortnitePID", "priority", "High")),
    Map("label", "Close Fortnite",   "x", 105, "y", 34,  "action", Map("killPidVar", "FortnitePID")),
    Map("label", "Open Battlefront", "x", 22,  "y", 90,  "action", Map("run", pcGameRoot . "Battlefront 2\FrostyModManager.lnk", "waitExe", "ahk_exe starwarsbattlefrontii.exe", "storePidVar", "BattlefrontPID", "priority", "High")),
    Map("label", "Close Battlefront","x", 105, "y", 90,  "action", Map("killPidVar", "BattlefrontPID")),
    Map("label", "Open Witcher 3",   "x", 22,  "y", 146, "action", Map("run", witcherExe, "storePidVar", "WitcherPID", "priority", "High")),
    Map("label", "Close Witcher 3",  "x", 105, "y", 146, "action", Map("killPidVar", "WitcherPID"))
]

; PC Utilities
pcUtilities := [
    Map("label", "Open Gameboost",  "x", 22,  "y", 34,  "action", Map("run", pcScriptsRoot . "Gameboost.ahk", "storePidVar", "GamePID")),
    Map("label", "Close Gameboost", "x", 105, "y", 34,  "action", Map("killPidVar", "GamePID"))
]

CreateLauncherGui(tabs, [laptopGeneral, laptopGames, pcGeneral, pcGames, pcUtilities], "All Launchers")
