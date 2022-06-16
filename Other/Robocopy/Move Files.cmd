robocopy "%USERPROFILE%\OneDriveBackup\Optimal\Files\Program Files (x86)" "C:" /MT:32 /z /j /s /e
robocopy "%USERPROFILE%\OneDrive\Backup\Optimal\Files\ProgramData" "C:" /MT:32 /z /j /s /e
robocopy "%USERPROFILE%\OneDrive\Backup\Optimal\Files\Users" %USERPROFILE% /MT:32 /z /j /s /e
exit