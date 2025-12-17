if (!A_IsAdmin) {
	Run % "*RunAs " A_ScriptFullPath
	ExitApp
}
UrlDownloadToFile https://www.autohotkey.com/download/ahk-install.exe
	, % A_Temp "\ahk-install.exe"
cmd := "ahk-install.exe /S /uiAccess=1 & del ahk-install.exe"
Run % A_ComSpec " /C """ cmd """", % A_Temp, Hide