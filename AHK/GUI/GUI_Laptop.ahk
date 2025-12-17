#Include %A_ScriptDir%\..\..\Lib\AHK_Common.ahk
#Include %A_ScriptDir%\GUI_Shared.ahk
InitScript(true, true)  ; UIA + Admin required

documentsScripts := A_MyDocuments . "\Scripts"
keysPath := documentsScripts . "\Keys.ahk"
hostPath := documentsScripts . "\Script Master\Host.ahk"
programFilesX86 := A_ProgramFiles
if (A_Is64bitOS && !InStr(programFilesX86, " (x86)"))
    programFilesX86 := A_ProgramFiles . " (x86)"
shellShockPath := programFilesX86 . "\Steam\steamapps\common\ShellShock Live\ShellShockLive.exe"
robosquarePath := programFilesX86 . "\Steam\steamapps\common\RoboSquare\RoboSquare.exe"
y8Url := "https://y8.com"

tabs := [{
    Name: "General",
    Buttons: [
        {Label: "Open Keys", Action: Func("OpenKeys")},
        {Label: "Close Keys", Action: Func("CloseKeys")},
        {Label: "Open Host", Action: Func("OpenHost")},
        {Label: "Close Host", Action: Func("CloseHost")}
    ]
}, {
    Name: "Games",
    Buttons: [
        {Label: "Open ShellShockLive", Action: Func("OpenShellShock")},
        {Label: "Close ShellShockLive", Action: Func("CloseShellShock")},
        {Label: "Open Robosquare", Action: Func("OpenRobosquare")},
        {Label: "Close Robosquare", Action: Func("CloseRobosquare")},
        {Label: "Open Y8 Games", Action: Func("OpenY8")},
        {Label: "Close Y8 Games", Action: Func("CloseY8")}
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

OpenShellShock() {
    Run, %shellShockPath%
}

CloseShellShock() {
    WinKill, ahk_exe ShellShockLive.exe
}

OpenRobosquare() {
    Run, %robosquarePath%
}

CloseRobosquare() {
    WinKill, ahk_exe RoboSquare.exe
}

OpenY8() {
    Run, %y8Url%
}

CloseY8() {
    IfWinExist, Y8 Games
    Winactivate, Y8 Games
    Send, ^w
}
