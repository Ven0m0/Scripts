#Include %A_ScriptDir%\GUI_Shared.ahk

laptopTabs := "General|Games"
EnvGet, userRoot, USERPROFILE
if (!userRoot)
  userRoot := "C:\Users\" . A_UserName
laptopScriptsRoot := userRoot . "\Documents\Scripts\"

laptopGeneralButtons := [
  {label: "Open Keys", x: 22, y: 34, action: {run: laptopScriptsRoot . "Keys.ahk", storePidVar: "KeysPID"}},
  {label: "Close Keys", x: 105, y: 34, action: {killPidVar: "KeysPID"}},
  {label: "Open Host", x: 22, y: 90, action: {run: laptopScriptsRoot . "Script Master\Host.ahk", storePidVar: "HostPID"}},
  {label: "Close Host", x: 105, y: 90, action: {killPidVar: "HostPID"}}
]

laptopGameButtons := [
  {label: "Open ShellShockLive", x: 22, y: 34, action: {run: "C:\Program Files (x86)\Steam\steamapps\common\ShellShock Live\ShellShockLive.exe"}},
  {label: "Close ShellShockLive", x: 105, y: 34, action: {killWinTitle: "ahk_exe ShellShockLive.exe"}},
  {label: "Open Robosquare", x: 22, y: 90, action: {run: "C:\Program Files (x86)\Steam\steamapps\common\RoboSquare\RoboSquare.exe"}},
  {label: "Close Robosquare", x: 105, y: 90, action: {killWinTitle: "ahk_exe RoboSquare.exe"}},
  {label: "Open Y8 Games", x: 22, y: 146, action: {run: "https://y8.com"}},
  {label: "Close Y8 Games", x: 105, y: 146, action: {activateTitle: "Y8 Games", sendKeys: "^w"}}
]

CreateLauncherGui(laptopTabs, [laptopGeneralButtons, laptopGameButtons])
return
