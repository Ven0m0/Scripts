taskkill /IM onedrive.exe /F
sc stop OneSyncSvc_4a414
sc stop FileSyncHelper
timeout /t 2 /nobreak >nul
sc start OneSyncSvc_4a414
sc start FileSyncHelper
exit