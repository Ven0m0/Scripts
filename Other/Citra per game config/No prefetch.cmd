@echo off 
SET Config= "%USERPROFILE%\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\config\qt-config.ini"
Set Prefetch= "%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Other\Playnite\Citra per game config\No prefetch\qt-config.ini"
Set Default= "%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Other\Playnite\Citra per game config\Default\qt-config.ini"

Copy %Config% %Default%
Copy %Prefetch% %Config%
exit