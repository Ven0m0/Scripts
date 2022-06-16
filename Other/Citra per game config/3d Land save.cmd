@echo off 
SET Config= "%USERPROFILE%\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\config\qt-config.ini"
Set Land= "%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Citra per game config\3d land\qt-config.ini"
Set Default= "%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Citra per game config\Default\qt-config.ini"

Copy %Config% %Land% 
Copy %Default% %Config%
pause