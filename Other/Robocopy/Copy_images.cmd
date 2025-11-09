set ext=*.jpg *.png *.webp *.bmp *.ico 
robocopy "input Path" "output path" %ext% /s /MT:32 /NJH /NFL /NC /NS /LOG:C:\Robocopy.log
del /F /Q C:\Robocopy.log
pause