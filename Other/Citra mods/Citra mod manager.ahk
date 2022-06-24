; UIA check
if (!InStr(A_AhkPath, "_UIA.exe")) {
	newPath := RegExReplace(A_AhkPath, "\.exe", "U" (32 << A_Is64bitOS) "_UIA.exe")
	Run % StrReplace(DllCall("Kernel32\GetCommandLine", "Str"), A_AhkPath, newPath)
	ExitApp
}

#SingleInstance Force
#Warn  ; Enable warnings to assist with detecting common errors.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Expedition := "C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\Mods\Super Mario 3d Land Expedition"
KaizoLand := "C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\Mods\Kaizo Mario 3D Land"
NSMBNext := "C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\Mods\NSMBNext The Lost Levels"
Mods := "C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\load\mods"

Gui, Add, Button, gExpeditionMod, Apply Expedition Mod
Gui, Add, Button, gDelExpedition, Delete Expedition Mod
Gui, Add, Button, gKaizoLandMod, Apply Kaizo Land Mod
Gui, Add, Button, gNSMBNextMod, Apply NSMBNext Mod
Gui, Show
return

ExpeditionMod:
if FileExist(Expedition) {
    FileCopyDir, %Expedition%, C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\load\mods\0004000000053F00\
}
Return

KaizoLandMod:
if FileExist(KaizoLand) {
    FileCopyDir, %KaizoLand%, C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\load\mods\0004000000053F00\
}
Return

NSMBNextMod:
if FileExist(NSMBNext) {
    FileCopyDir, %NSMBNext%, C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\load\mods\000400000007AF00\
}
Return

DelExpedition:
if FileExist("C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\load\mods\0004000000053F00\romfs") {
    FileRemoveDir, %Mods%\0004000000053F00, 1
}
Return