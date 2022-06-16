@echo off 
SET ConfigFolder=%USERPROFILE%\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\config
Set Prefetch= "%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Citra per game config\No prefetch\qt-config.ini"

Copy %Prefetch% %ConfigFolder%
exit