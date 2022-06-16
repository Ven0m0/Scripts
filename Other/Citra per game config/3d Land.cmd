@echo off 
SET ConfigFolder=%USERPROFILE%\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\config
Set Land= "%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Citra per game config\3d land\qt-config.ini"

Copy %Land% %ConfigFolder%
exit