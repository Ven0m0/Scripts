@ECHO OFF
START "" "C:\Program Files\VideoLAN\VLC\vlc.exe" --fullscreen --video-on-top --play-and-exit --no-video-title -Idummy "%USERPROFILE%\OneDrive\Backup\Optimal\Scripts\Other\Playnite\Playnite Fullscreen\BootVideo.mp4"
TIMEOUT /T 3
runas /noprofile /user:janni /savecred "%USERPROFILE%\OneDrive\Backup\Game\Other\Launchers\Playnite\Playnite.FullscreenApp.exe --hidesplashscreen"
exit