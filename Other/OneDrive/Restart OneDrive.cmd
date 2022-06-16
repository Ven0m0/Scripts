taskkill /IM onedrive.exe /F
sc stop OneSyncSvc_4a414
sc stop FileSyncHelper
timeout /t 2 /nobreak >nul
sc start OneSyncSvc_4a414
sc start FileSyncHelper
start cmd.exe @cmd /k "cd C:\Program Files\Microsoft OneDrive&OneDrive.exe"
pause