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

Loop, Files, C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\Mods\*.*, d
    if FileExist("C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\Mods\Super Mario 3d Land Expedition") {
        FileCreateDir, "C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\load\mods\0004000000053F00"
        FileCopyDir, "C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\Mods\Super Mario 3d Land Expedition", "C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\load\mods\0004000000053F00"
    }
    if FileExist("C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\Mods\Kaizo Mario 3D Land") {
        FileCreateDir, "C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\load\mods\0004000000053F00
        FileCopyDir, "C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\Mods\Kaizo Mario 3D Land", "C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\load\mods\0004000000053F00"
    }
    if FileExist("C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\Mods\SMBNext The Lost Levels") {
        FileCreateDir, "C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\load\mods\000400000007AF00"
        FileCopyDir, "C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\Mods\SMBNext The Lost Levels", "C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\load\mods\000400000007AF00"
    }