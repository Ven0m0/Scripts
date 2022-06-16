@echo off 
SET Config= "%USERPROFILE%\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\config\qt-config.ini"
Set Prefetch= "%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Citra per game config\Default\qt-config.ini"

Copy %Prefetch% %Config%
pause