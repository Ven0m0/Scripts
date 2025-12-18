[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$SevenZipPath,          # Path to 7z.exe
    [Parameter(Mandatory)]
    [string]$EmulatorPath,          # Path to emulator exe
    [Parameter()]
    [string]$EmulatorArguments = "",# Arguments for emulator (single string)
    [Parameter(Mandatory)]
    [string]$ExtractionPath,        # Where to extract
    [Parameter(Mandatory)]
    [string]$ArchivePath,           # Compressed file
    [Parameter(Mandatory)]
    [string]$LaunchExtensions,      # Extension(s) to launch, e.g. ".iso" or ".iso,.bin"
    [switch]$KeepExtracted          # Keep extracted content
)

$ErrorActionPreference = "Stop"

function Write-Info { param($msg) Write-Host $msg }
function Fail { param($msg) Write-Error $msg; exit 1 }

function Validate-Path {
    param($path, [switch]$File, [switch]$Dir, [string]$name)
    if ($File -and -not (Test-Path $path -PathType Leaf)) { Fail "$name not found: $path" }
    if ($Dir  -and -not (Test-Path $path -PathType Container)) { Fail "$name not found: $path" }
}

function Normalize-Extensions {
    param($extString)
    $exts = $extString -split "," | ForEach-Object { $_.Trim() }
    $exts = $exts | Where-Object { $_ -ne "" } | ForEach-Object {
        if ($_ -notmatch '^\.') { ".$_" } else { $_ }
    }
    if (-not $exts) { Fail "No launch extensions provided." }
    return $exts
}

function Find-LaunchFile {
    param($baseName, $extensions)
    foreach ($ext in $extensions) {
        $match = Get-ChildItem -LiteralPath . -Filter "$baseName*$ext" -File -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($match) { return $match.FullName }
    }
    return $null
}

function Extract-Archive {
    param($sevenZip, $archive, $outDir)
    Write-Info "Extracting [$archive]..."
    $progressPattern = '\d{1,3}%'
    & $sevenZip "x" $archive "-o$outDir" "-aos" "-bsp1" |
        Select-String -Pattern $progressPattern -AllMatches |
        ForEach-Object {
            $pct = $_.Matches.Value | Select-Object -Last 1
            if ($pct) {
                [Console]::SetCursorPosition(0, [Console]::CursorTop)
                Write-Host -NoNewline "Progress: $pct"
            }
        }
    Write-Host
}

function Launch-Emulator {
    param($emu, $args, $fileToLaunch)
    Write-Info "Launching [$fileToLaunch]..."
    $fullArgs = $args
    if ($fullArgs -ne "") { $fullArgs += " " }
    $fullArgs += ('"{0}"' -f $fileToLaunch)
    Start-Process -FilePath $emu -ArgumentList $fullArgs -Wait
}

# --- Validation ---
Validate-Path -File $SevenZipPath -name "7-Zip"
Validate-Path -File $EmulatorPath -name "Emulator"
Validate-Path -File $ArchivePath -name "Archive"
if (-not (Test-Path $ExtractionPath -PathType Container)) { New-Item -ItemType Directory -Path $ExtractionPath | Out-Null }

$baseName   = [IO.Path]::GetFileNameWithoutExtension($ArchivePath)
$extensions = Normalize-Extensions $LaunchExtensions

Write-Host "------------------------------------------------------------"
Write-Host "7Z-Emu-Prepper"
Write-Host "------------------------------------------------------------"
Write-Host "7Zip          = $SevenZipPath"
Write-Host "Emulator      = $EmulatorPath"
Write-Host "Emu Args      = $EmulatorArguments"
Write-Host "Archive       = $ArchivePath"
Write-Host "Extracting To = $ExtractionPath"
Write-Host "Launch Ext(s) = $($extensions -join ', ')"
Write-Host "Keep Extract  = $KeepExtracted"
Write-Host "------------------------------------------------------------"

Push-Location $ExtractionPath
try {
    $existing = Find-LaunchFile -baseName $baseName -extensions $extensions
    if ($existing) {
        Write-Info "Archive already extracted. Found: [$existing]"
        Launch-Emulator -emu $EmulatorPath -args $EmulatorArguments -fileToLaunch $existing
    } else {
        Extract-Archive -sevenZip $SevenZipPath -archive $ArchivePath -outDir $ExtractionPath
        $extracted = Find-LaunchFile -baseName $baseName -extensions $extensions
        if (-not $extracted) { Fail "No matching file found after extraction for extensions: $($extensions -join ', ')" }
        Launch-Emulator -emu $EmulatorPath -args $EmulatorArguments -fileToLaunch $extracted
        if (-not $KeepExtracted) {
            Write-Info "Removing extracted files..."
            Remove-Item -LiteralPath ($baseName + "*") -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    Write-Info "Process complete."
} finally {
    Pop-Location
}
