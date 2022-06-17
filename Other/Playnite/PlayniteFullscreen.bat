@ECHO OFF
START "" "C:\Program Files\VideoLAN\VLC\vlc.exe" --fullscreen --video-on-top --play-and-exit --no-video-title -Idummy "%USERPROFILE%\OneDrive\Backup\Game\Other\Launchers\Playnite\Videos\BootVideo.mp4"
TIMEOUT /T 3
START "" "%USERPROFILE%\OneDrive\Backup\Game\Other\Launchers\Playnite\Playnite.FullscreenApp.exe" --hidesplashscreen
exit