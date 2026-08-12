# YouTube & Spotify Downloader

AutoHotkey v2 GUI wrapper around `yt-dlp` and `spotdl`.

## Scripts

| Script | Purpose |
|--------|---------|
| `YT_Spotify_Downloader.ahk` | GUI: paste a YouTube or Spotify URL, review the composed command, run it |
| `Update-Downloaders.ps1` | Updates `yt-dlp.exe` / `spotdl.exe` to the latest release |

## Prerequisites

- `yt-dlp.exe` - [releases](https://github.com/yt-dlp/yt-dlp/releases)
- `spotdl.exe` - [releases](https://github.com/spotDL/spotify-downloader/releases) (rename the
  downloaded exe to exactly `spotdl.exe`)
- `ffmpeg.exe` - required by both for audio muxing

The script resolves both executables via `MustGetExe()` (`Lib/AHK_Common.ahk`): PATH first,
then this directory as a fallback. It exits with an error if either is missing.

## Usage

1. Place `yt-dlp.exe`, `spotdl.exe`, and `ffmpeg.exe` on PATH or in this directory.
2. Run `YT_Spotify_Downloader.ahk`.
3. Paste a URL into the YouTube or Spotify field — the composed command appears in the output box.
4. Click **Run Command**. Output is downloaded to `%USERPROFILE%\Music`.

Input is validated against shell metacharacters (`& | ; < > ( ) $ \` ^ "`) before the command
runs, to prevent command injection through a malicious URL. Do not remove this check.

---

- [ahk/README.md](../README.md) - parent directory documentation
- [AGENTS.md](../../AGENTS.md) - developer guide
