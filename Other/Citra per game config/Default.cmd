@echo off 
SET ConfigFolder= "%USERPROFILE%\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\config"
Set Default= "%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Citra per game config\Default\qt-config.ini"

Copy %Default% %ConfigFolder%
exit