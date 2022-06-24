@echo off 
Set Config= "%USERPROFILE%\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\config\qt-config.ini"
Set Land= "%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Other\Playnite\Citra per game config\3d Land\qt-config.ini"
Set Default= "%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Other\Playnite\Citra per game config\Default\qt-config.ini"

Copy %Config% %Default%
Copy %Land% %Config%
exit