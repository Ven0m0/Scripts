You need to replace the path in the scripts with your citra folder.

Example from this:
TF_ReplaceInLines("!C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\canary-mingw\user\config\qt-config.ini","641","641","8","10")

To this
TF_ReplaceInLines("!C:/Users/[your-user-name]/AppData/Roaming/Citra\canary-mingw\user\config\qt-config.ini","641","641","8","10")