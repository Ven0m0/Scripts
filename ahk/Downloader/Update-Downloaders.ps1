<#
.SYNOPSIS
    Updates yt-dlp and spotdl to latest versions
.DESCRIPTION
    Automatically updates media downloader tools to their latest versions
.NOTES
    Migrated from update.cmd - 2025-12-26
#>
[CmdletBinding()]
param()

$ErrorActionPreference = "Continue"
Set-Location $PSScriptRoot

Write-Host "Updating media downloaders..." -ForegroundColor Cyan

# Update yt-dlp
if (Test-Path ".\yt-dlp.exe") {
    Write-Host "`nUpdating yt-dlp..." -ForegroundColor Yellow
    & .\yt-dlp.exe --rm-cache-dir -U --update-to nightly
    if ($LASTEXITCODE -eq 0) {
        Write-Host "yt-dlp updated successfully" -ForegroundColor Green
    } else {
        Write-Warning "yt-dlp update failed (exit code: $LASTEXITCODE)"
    }
} else {
    Write-Warning "yt-dlp.exe not found in $PSScriptRoot"
}

# Update spotdl
if (Test-Path ".\spotdl.exe") {
    Write-Host "`nDownloading ffmpeg for spotdl..." -ForegroundColor Yellow
    & .\spotdl.exe --download-ffmpeg
    if ($LASTEXITCODE -eq 0) {
        Write-Host "spotdl ffmpeg updated successfully" -ForegroundColor Green
    } else {
        Write-Warning "spotdl ffmpeg download failed"
    }
} else {
    Write-Warning "spotdl.exe not found in $PSScriptRoot"
}

Write-Host "`nUpdate complete!" -ForegroundColor Green
Start-Sleep -Seconds 2
