cd /d %~dp0
yt-dlp.exe  -U
timeout 1
spotdl.exe --download-ffmpeg
exit
