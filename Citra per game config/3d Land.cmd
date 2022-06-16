@echo off 
SET ConfigFolder=%USERPROFILE%\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\config
Set Land= "%USERPROFILE%\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\Game configs\3d land\qt-config.ini"

Copy %Land% %ConfigFolder%
exit