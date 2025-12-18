cd /d %~dp0
yt-dlp.exe --rm-cache-dir -U --update-to nightly
timeout 1
spotdl.exe --download-ffmpeg
exit
