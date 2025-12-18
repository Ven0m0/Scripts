@echo off
setlocal enabledelayedexpansion

if "%~1"=="" goto :usage
if "%~2"=="" goto :usage
set "SRC=%~1"
set "DST=%~2"
set "THREADS=32"
set "BASE_OPTS=/COPY:DAT /DCOPY:DAT /R:1 /W:1 /NFL /NDL /NJH /NJS /NP"
set "DIR_OPTS=/E /MT:%THREADS%"

REM --- Source check ---
if exist "%SRC%\" (
  goto :copy_dir
) else if exist "%SRC%" (
  goto :copy_file
) else (
  echo Source not found: "%SRC%"
  exit /b 1
)
:copy_file
set "SRCNAME=%~nx1"
set "SRCDIR=%~dp1"
set "DESTISDIR=0"
if exist "%DST%\NUL" set "DESTISDIR=1"
if exist "%DST%\"     set "DESTISDIR=1"
if "%DESTISDIR%"=="1" (
  set "DESTDIR=%DST%"
  set "DESTNAME=%SRCNAME%"
) else (
  set "DESTDIR=%~dp2"
  if "%DESTDIR%"=="" set "DESTDIR=%CD%"
  set "DESTNAME=%~nx2"
)
if not exist "%DESTDIR%" mkdir "%DESTDIR%"
if exist "%DESTDIR%\%DESTNAME%" del /f /q "%DESTDIR%\%DESTNAME%"

robocopy "%SRCDIR%" "%DESTDIR%" "%SRCNAME%" %BASE_OPTS%
set "RC=%errorlevel%"

if not "%DESTNAME%"=="%SRCNAME%" (
  if exist "%DESTDIR%\%SRCNAME%" ren "%DESTDIR%\%SRCNAME%" "%DESTNAME%"
)
exit /b %RC%

:copy_dir
if exist "%DST%" (
  if not exist "%DST%\NUL" (
    echo Destination exists and is a file: "%DST%"
    exit /b 1
  )
) else (
  mkdir "%DST%"
)
robocopy "%SRC%" "%DST%" * %BASE_OPTS% %DIR_OPTS%
exit /b %errorlevel%

:usage
echo Usage:
echo   %~nx0 ^<source_file_or_dir^> ^<dest_file_or_dir^>
echo Examples:
echo   %~nx0 "C:\path\file.txt" "D:\backup\"
echo   %~nx0 "C:\path\file.txt" "D:\backup\file-new.txt"
echo   %~nx0 "C:\path\folder"   "D:\backup\folder"
exit /b 1
