# YouTube & Spotify Downloader

GUI-based media downloaders for YouTube videos/audio and Spotify playlists/tracks.

## Overview

This directory contains AutoHotkey v1 scripts that provide a user-friendly graphical interface for downloading media from YouTube and Spotify using `yt-dlp` and `spotdl` backends.

## Features

- **YouTube Downloader** - Download videos or extract audio from YouTube
- **Spotify Downloader** - Download songs from Spotify playlists or tracks
- **Combined Downloader** - All-in-one interface for both services
- **Quality Selection** - Choose video resolution and audio bitrate
- **GUI Interface** - No command-line knowledge required
- **Automatic Updates** - Update yt-dlp via included script

## Scripts

| Script | Purpose |
|--------|---------|
| `YT_Spotify_Downloader.ahk` | Combined YouTube/Spotify downloader (recommended) |
| `update.cmd` | Updates yt-dlp to the latest version |

## Prerequisites

### Required Downloads

1. **yt-dlp** (YouTube downloader backend)
   - Download: [yt-dlp releases](https://github.com/yt-dlp/yt-dlp/releases)
   - Get: `yt-dlp.exe` (Windows executable)
   - Place in the same folder as the scripts

2. **spotdl** (Spotify downloader backend)
   - Download: [spotdl releases](https://github.com/spotDL/spotify-downloader/releases)
   - Get: `spotdl.exe` (Windows executable)
   - **Important:** Rename the file to exactly `spotdl.exe`
   - Place in the same folder as the scripts

3. **FFMPEG** (Required for audio processing)
   - Run the included `update.cmd` file to automatically download FFMPEG
   - Or download manually from [ffmpeg.org](https://ffmpeg.org/download.html)
   - Place `ffmpeg.exe` in the same folder

### Software Requirements

- **AutoHotkey v1.1.37.02+** - [Download](https://www.autohotkey.com/)
- **Windows 10/11** - Required for the executables
- **Internet connection** - For downloading media

## Installation

### Quick Setup

1. **Download dependencies:**
   ```bash
   # Place these files in Other/Downloader/:
   - yt-dlp.exe
   - spotdl.exe  (renamed from spotdl-*.exe)
   - ffmpeg.exe  (run update.cmd or download manually)
   ```

2. **Verify file structure:**
   ```
   Other/Downloader/
   ├── YT_Spotify_Downloader.ahk
   ├── update.cmd
   ├── yt-dlp.exe          ← Download this
   ├── spotdl.exe          ← Download and rename this
   └── ffmpeg.exe          ← Run update.cmd or download
   ```

3. **Run the downloader:**
   ```bash
   # Double-click to run
   YT_Spotify_Downloader.ahk
   ```

### Detailed Setup Steps

#### Step 1: Download yt-dlp

1. Go to [yt-dlp releases](https://github.com/yt-dlp/yt-dlp/releases)
2. Download `yt-dlp.exe` from the latest release
3. Move it to `Other/Downloader/`

#### Step 2: Download spotdl

1. Go to [spotdl releases](https://github.com/spotDL/spotify-downloader/releases)
2. Download the Windows executable (e.g., `spotdl-4.2.0-win32.exe`)
3. **Rename it to exactly `spotdl.exe`**
4. Move it to `Other/Downloader/`

#### Step 3: Get FFMPEG

**Method 1: Automatic (Recommended)**
```bash
# Run the update script
update.cmd
```

**Method 2: Manual**
1. Download FFMPEG from [ffmpeg.org](https://ffmpeg.org/download.html)
2. Extract `ffmpeg.exe` from the archive
3. Move it to `Other/Downloader/`

## Usage

### YouTube Downloads

1. **Launch the downloader:**
   ```bash
   YT_Spotify_Downloader.ahk
   ```

2. **Enter YouTube URL:**
   - Paste video URL (e.g., `https://youtube.com/watch?v=...`)
   - Or playlist URL

3. **Select quality:**
   - Video: 1080p, 720p, 480p, etc.
   - Audio: MP3, M4A, FLAC

4. **Click Download**

5. **Files saved to:**
   ```
   C:\Users\YourName\Music\
   ```

### Spotify Downloads

1. **Launch the downloader**

2. **Enter Spotify URL:**
   - Track: `https://open.spotify.com/track/...`
   - Playlist: `https://open.spotify.com/playlist/...`
   - Album: `https://open.spotify.com/album/...`

3. **Click Download**

4. **Files saved to:**
   ```
   C:\Users\YourName\Music\
   ```

### Output Location

By default, all downloads are saved to your **Music folder**:
```
C:\Users\[YourUsername]\Music\
```

## Configuration

### Changing Output Directory

Edit the script to change where files are saved:

```autohotkey
; Find this line in YT_Spotify_Downloader.ahk
outputPath := A_MyDocuments . "\Music"

; Change to your preferred location
outputPath := "D:\Downloads\Music"
```

### Changing Default Quality

```autohotkey
; YouTube default quality (find and edit)
defaultQuality := "1080"  ; Change to: 720, 480, 360

; Audio default format
defaultFormat := "mp3"  ; Change to: m4a, flac, wav
```

## Updating

### Update yt-dlp

```bash
# Run the update script
update.cmd

# Or download latest manually from GitHub
```

### Update spotdl

1. Download latest release
2. Rename to `spotdl.exe`
3. Replace old file

## Troubleshooting

### Issue: "File not found" error

**Cause:** Dependencies not in correct location

**Solution:**
1. Verify all files are in `Other/Downloader/` directory
2. Check file names are **exact**:
   - `yt-dlp.exe` (not `yt-dlp-*.exe`)
   - `spotdl.exe` (not `spotdl-4.2.0-win32.exe`)
   - `ffmpeg.exe` (not `ffmpeg-*.exe`)

### Issue: Downloads fail

**Cause:** Outdated yt-dlp or spotdl

**Solution:**
```bash
# Update yt-dlp
update.cmd

# Redownload spotdl latest version
```

### Issue: No audio in video

**Cause:** Missing FFMPEG

**Solution:**
1. Run `update.cmd` to get FFMPEG
2. Or download manually and place in folder

### Issue: Spotify downloads incomplete

**Possible causes:**
1. Invalid Spotify URL
2. Private playlist
3. Spotdl not authenticated

**Solution:**
- Ensure playlist/track is public
- Check URL is correct format
- Try re-downloading spotdl

### Issue: Script won't run

**Cause:** AutoHotkey not installed or wrong version

**Solution:**
1. Install AutoHotkey v1.1.37.02+
2. Right-click script → Run as Administrator

## Security Note

⚠️ **Input Validation:** The scripts have been updated with input validation to prevent command injection vulnerabilities. Do not modify the validation code unless you understand the security implications.

```autohotkey
; Security feature - do not remove
ValidateInput(input) {
    if RegExMatch(input, "[&|;<>()`$^""]") {
        return false
    }
    return true
}
```

## Legal Notice

**Important:** Downloading copyrighted content may violate laws in your country. These tools are provided for:

- Downloading your own content
- Content with explicit permission
- Public domain content
- Fair use purposes

**The authors are not responsible for any misuse of these tools.**

## Known Limitations

1. **YouTube:**
   - Age-restricted videos may require cookies
   - Some videos may be geo-blocked
   - Live streams not supported

2. **Spotify:**
   - Requires songs to be on YouTube (uses YouTube as source)
   - May not match exact Spotify version
   - Quality depends on YouTube source

## Advanced Usage

### Custom yt-dlp Parameters

Edit script to add custom parameters:

```autohotkey
; Add custom yt-dlp options
customParams := "--add-metadata --embed-thumbnail"
cmd := ytdlpPath . " " . customParams . " " . url
```

### Batch Downloads

For multiple URLs, create a text file with one URL per line, then modify script to read from file.

## Screenshot

![Downloader Interface](Downloader.avif)

## Resources

- [yt-dlp Documentation](https://github.com/yt-dlp/yt-dlp#readme)
- [spotdl Documentation](https://github.com/spotDL/spotify-downloader#readme)
- [FFMPEG Documentation](https://ffmpeg.org/documentation.html)

## Contributing

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for contribution guidelines.

---

**Last Updated:** 2025-12-26
