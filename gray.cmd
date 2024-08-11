@echo off
setlocal enabledelayedexpansion

cls
echo ================ Image Inverter ================

set "SCRIPT_FOLDER=%~dp0"
set "IMAGEMAGICK_FOLDER=%SCRIPT_FOLDER%"

rem 사용자 지정 바탕화면 경로 확인
for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Desktop') do set "DESKTOP_FOLDER=%%b"

rem 환경 변수 확장
call set "DESKTOP_FOLDER=%DESKTOP_FOLDER%"

set "WORK_FOLDER=%DESKTOP_FOLDER%\gray_invert"
set "INPUT_FOLDER=%WORK_FOLDER%"
set "OUTPUT_FOLDER=%WORK_FOLDER%"

set "PATH=%IMAGEMAGICK_FOLDER%;%PATH%"

if not exist "%WORK_FOLDER%" (
    echo Creating work folder: %WORK_FOLDER%
    mkdir "%WORK_FOLDER%"
)

echo Input/Output: %WORK_FOLDER%

echo.
echo Input files:
dir /b "%INPUT_FOLDER%" 2>nul || echo No input files found.

set "EXTENSIONS=png jpg jpeg gif"
set "PROCESSED_COUNT=0"

echo.
echo Processing:
for %%E in (%EXTENSIONS%) do (
    for %%F in ("%INPUT_FOLDER%\*.%%E") do (
        echo  %%~nxF -^> %%~nF_inverted%%~xF
        magick "%%F" -negate -colorspace gray "%OUTPUT_FOLDER%\%%~nF_inverted%%~xF"
        if !errorlevel! neq 0 (
            echo   Error processing %%~nxF
        ) else (
            set /a PROCESSED_COUNT+=1
        )
    )
)

echo.
echo Processed: %PROCESSED_COUNT% image(s)

if %PROCESSED_COUNT% gtr 0 (
    echo.
    echo Output files:
    dir /b "%OUTPUT_FOLDER%\*_inverted*"
)

echo.
echo ================ Process Complete ================
pause
