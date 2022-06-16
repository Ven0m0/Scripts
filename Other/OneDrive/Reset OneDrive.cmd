sc stop OneSyncSvc_4a414
sc stop FileSyncHelper
timeout /t 2 /nobreak >nul
sc start OneSyncSvc_4a414
sc start FileSyncHelper
cd C:\Users\janni\AppData\Local\Microsoft\OneDrive
onedrive.exe /reset
timeout /t 2 /nobreak >nul
exit

