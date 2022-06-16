@echo off 
SET ConfigFolder=%USERPROFILE%\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\config
Set Prefetch= "%USERPROFILE%\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\Game configs\No prefetch\qt-config.ini"

Copy %Prefetch% %ConfigFolder%
exit