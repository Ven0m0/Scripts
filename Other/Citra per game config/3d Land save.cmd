@echo off 
SET ConfigFolder=%USERPROFILE%\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\config
Set GameConfig=%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Citra per game config
Set Land=%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Citra per game config\3d land\qt-config.ini
Set Default=%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Citra per game config\Default\qt-config.ini

Copy %Land% %Gameconfig%\3d land
Copy %Default% %ConfigFolder%
exit