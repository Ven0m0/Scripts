#Include %A_ScriptDir%\GUI_Shared.ahk

pcTabs := "General|Games|Utilities"
EnvGet, userRoot, USERPROFILE
if (!userRoot)
  userRoot := "C:\Users\" . A_UserName
scriptsRoot := userRoot . "\OneDrive\Backup\Optimal\Scripts\AHK\"
gameRoot := userRoot . "\OneDrive\Backup\Game\Steam\"
fortniteExe := "C:\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe"
witcherExe := "C:\Program Files (x86)\Steam\steamapps\common\The Witcher 3\bin\x64\witcher3.exe"

pcGeneralButtons := [
  {label: "Open Keys", x: 22, y: 34, action: {run: scriptsRoot . "Keys.ahk", storePidVar: "KeysPID"}},
  {label: "Close Keys", x: 105, y: 34, action: {killPidVar: "KeysPID"}},
  {label: "Open Host", x: 22, y: 90, action: {run: scriptsRoot . "Script Master\Host.ahk", storePidVar: "HostPID"}},
  {label: "Close Host", x: 105, y: 90, action: {killPidVar: "HostPID"}},
  {label: "Open Autocorrect", x: 22, y: 146, action: {run: scriptsRoot . "Autocorrect.ahk", storePidVar: "AutocorrectPID"}},
  {label: "Close Autocorrect", x: 105, y: 146, action: {killPidVar: "AutocorrectPID"}}
]

pcGameButtons := [
  {label: "Open Fortnite", x: 22, y: 34, action: {run: fortniteExe, storePidVar: "FortnitePID", priority: "High"}},
  {label: "Close Fortnite", x: 105, y: 34, action: {killPidVar: "FortnitePID"}},
  {label: "Open Battlefront", x: 22, y: 90, action: {run: gameRoot . "Battlefront 2\FrostyModManager.lnk", waitExe: "ahk_exe starwarsbattlefrontii.exe", storePidVar: "BattlefrontPID", priority: "High"}},
  {label: "Close Battlefront", x: 105, y: 90, action: {killPidVar: "BattlefrontPID"}},
  {label: "Open The Witcher 3", x: 22, y: 146, action: {run: witcherExe, storePidVar: "WitcherPID", priority: "High"}},
  {label: "Close The Witcher 3", x: 105, y: 146, action: {killPidVar: "WitcherPID"}}
]

pcUtilityButtons := [
  {label: "Open Gameboost", x: 22, y: 34, action: {run: scriptsRoot . "Gameboost.ahk", storePidVar: "GamePID"}},
  {label: "Close Gameboost", x: 105, y: 34, action: {killPidVar: "GamePID"}}
]

CreateLauncherGui(pcTabs, [pcGeneralButtons, pcGameButtons, pcUtilityButtons])
return
