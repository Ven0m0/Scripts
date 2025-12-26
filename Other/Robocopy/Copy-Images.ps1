<#
.SYNOPSIS
    Copies image files using robocopy with multi-threading
.DESCRIPTION
    Recursively copies image files from source to destination using robocopy
.PARAMETER Source
    Source directory path
.PARAMETER Destination
    Destination directory path
.PARAMETER Threads
    Number of threads for robocopy (default: 32)
.NOTES
    Migrated from Copy_images.cmd - 2025-12-26
.EXAMPLE
    .\Copy-Images.ps1 -Source "C:\Pictures" -Destination "D:\Backup\Pictures"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$false, Position=0)]
    [string]$Source = "input Path",

    [Parameter(Mandatory=$false, Position=1)]
    [string]$Destination = "output path",

    [ValidateRange(1, 128)]
    [int]$Threads = 32
)

$ErrorActionPreference = "Stop"

# Image extensions
$extensions = "*.jpg *.png *.webp *.bmp *.ico"

Write-Host "Copying images from '$Source' to '$Destination'..." -ForegroundColor Cyan

# Execute robocopy
$result = robocopy "$Source" "$Destination" $extensions /s /MT:$Threads /NJH /NFL /NC /NS

# Robocopy exit codes: 0-7 are success, 8+ are errors
if ($LASTEXITCODE -lt 8) {
    Write-Host "Copy completed successfully" -ForegroundColor Green
    exit 0
} else {
    Write-Error "Robocopy failed with exit code $LASTEXITCODE"
    exit 1
}
