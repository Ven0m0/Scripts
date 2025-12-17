#Requires AutoHotkey v2.0

; ============================================================================
; GUI_PC.ahk - GUI launcher for PC-specific scripts
; Version: 2.0.0 (Migrated to AHK v2)
; ============================================================================

#Include %A_ScriptDir%\GUI_Shared.ahk

pcTabs := "General|Games|Utilities"

; Determine user paths
userRoot := EnvGet("USERPROFILE")
if (!userRoot)
    userRoot := "C:\Users\" . A_UserName

; Update these paths to match your setup
scriptsRoot := userRoot . "\OneDrive\Backup\Optimal\Scripts\AHK\"
gameRoot := userRoot . "\OneDrive\Backup\Game\Steam\"
fortniteExe := "C:\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe"
witcherExe := "C:\Program Files (x86)\Steam\steamapps\common\The Witcher 3\bin\x64\witcher3.exe"

; General tab buttons
pcGeneralButtons := [
    Map("label", "Open Keys", "x", 22, "y", 34, "action", Map("run", scriptsRoot . "Keys.ahk", "storePidVar", "KeysPID")),
    Map("label", "Close Keys", "x", 105, "y", 34, "action", Map("killPidVar", "KeysPID")),
    Map("label", "Open Host", "x", 22, "y", 90, "action", Map("run", scriptsRoot . "Script Master\Host.ahk", "storePidVar", "HostPID")),
    Map("label", "Close Host", "x", 105, "y", 90, "action", Map("killPidVar", "HostPID")),
    Map("label", "Open Autocorrect", "x", 22, "y", 146, "action", Map("run", scriptsRoot . "Autocorrect.ahk", "storePidVar", "AutocorrectPID")),
    Map("label", "Close Autocorrect", "x", 105, "y", 146, "action", Map("killPidVar", "AutocorrectPID"))
]

; Games tab buttons
pcGameButtons := [
    Map("label", "Open Fortnite", "x", 22, "y", 34, "action", Map("run", fortniteExe, "storePidVar", "FortnitePID", "priority", "High")),
    Map("label", "Close Fortnite", "x", 105, "y", 34, "action", Map("killPidVar", "FortnitePID")),
    Map("label", "Open Battlefront", "x", 22, "y", 90, "action", Map("run", gameRoot . "Battlefront 2\FrostyModManager.lnk", "waitExe", "ahk_exe starwarsbattlefrontii.exe", "storePidVar", "BattlefrontPID", "priority", "High")),
    Map("label", "Close Battlefront", "x", 105, "y", 90, "action", Map("killPidVar", "BattlefrontPID")),
    Map("label", "Open The Witcher 3", "x", 22, "y", 146, "action", Map("run", witcherExe, "storePidVar", "WitcherPID", "priority", "High")),
    Map("label", "Close The Witcher 3", "x", 105, "y", 146, "action", Map("killPidVar", "WitcherPID"))
]

; Utilities tab buttons
pcUtilityButtons := [
    Map("label", "Open Gameboost", "x", 22, "y", 34, "action", Map("run", scriptsRoot . "Gameboost.ahk", "storePidVar", "GamePID")),
    Map("label", "Close Gameboost", "x", 105, "y", 34, "action", Map("killPidVar", "GamePID"))
]

CreateLauncherGui(pcTabs, [pcGeneralButtons, pcGameButtons, pcUtilityButtons], "PC Launcher")
