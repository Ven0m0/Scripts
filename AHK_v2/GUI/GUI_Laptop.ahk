#Requires AutoHotkey v2.0

; ============================================================================
; GUI_Laptop.ahk - GUI launcher for laptop-specific scripts
; Version: 2.0.0 (Migrated to AHK v2)
; ============================================================================

#Include %A_ScriptDir%\GUI_Shared.ahk

laptopTabs := "General|Games"

; Determine user paths
userRoot := EnvGet("USERPROFILE")
if (!userRoot)
    userRoot := "C:\Users\" . A_UserName

; Update this path to match your setup
laptopScriptsRoot := userRoot . "\Documents\Scripts\"

; General tab buttons
laptopGeneralButtons := [
    Map("label", "Open Keys", "x", 22, "y", 34, "action", Map("run", laptopScriptsRoot . "Keys.ahk", "storePidVar", "KeysPID")),
    Map("label", "Close Keys", "x", 105, "y", 34, "action", Map("killPidVar", "KeysPID")),
    Map("label", "Open Host", "x", 22, "y", 90, "action", Map("run", laptopScriptsRoot . "Script Master\Host.ahk", "storePidVar", "HostPID")),
    Map("label", "Close Host", "x", 105, "y", 90, "action", Map("killPidVar", "HostPID"))
]

; Games tab buttons
laptopGameButtons := [
    Map("label", "Open ShellShockLive", "x", 22, "y", 34, "action", Map("run", "C:\Program Files (x86)\Steam\steamapps\common\ShellShock Live\ShellShockLive.exe")),
    Map("label", "Close ShellShockLive", "x", 105, "y", 34, "action", Map("killWinTitle", "ahk_exe ShellShockLive.exe")),
    Map("label", "Open Robosquare", "x", 22, "y", 90, "action", Map("run", "C:\Program Files (x86)\Steam\steamapps\common\RoboSquare\RoboSquare.exe")),
    Map("label", "Close Robosquare", "x", 105, "y", 90, "action", Map("killWinTitle", "ahk_exe RoboSquare.exe")),
    Map("label", "Open Y8 Games", "x", 22, "y", 146, "action", Map("run", "https://y8.com")),
    Map("label", "Close Y8 Games", "x", 105, "y", 146, "action", Map("activateTitle", "Y8 Games", "sendKeys", "^w"))
]

CreateLauncherGui(laptopTabs, [laptopGeneralButtons, laptopGameButtons], "Laptop Launcher")
