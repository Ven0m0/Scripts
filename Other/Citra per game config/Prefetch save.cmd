@echo off 
SET ConfigFolder=%USERPROFILE%\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\config
Set GameConfig=%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Citra per game config
Set Prefetch=%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Citra per game config\No prefetch\qt-config.ini
Set Default=%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Citra per game config\Default\qt-config.ini

Copy %Prefetch% %Gameconfig%\3d land
Copy %Default% %ConfigFolder%
exit