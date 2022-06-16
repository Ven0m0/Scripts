@echo off 
SET Config= "%USERPROFILE%\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\config\qt-config.ini"
Set Land= "%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Citra per game config\3d Land\qt-config.ini"

Copy %Land% %Config%
exit