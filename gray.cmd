@echo off
setlocal enabledelayedexpansion

cls
echo ================ Image Inverter ================

set "SCRIPT_FOLDER=%~dp0"
set "IMAGEMAGICK_FOLDER=%SCRIPT_FOLDER%"
set "WORK_FOLDER=D:\khkim\Desktop\gray_invert"
set "INPUT_FOLDER=%WORK_FOLDER%"
set "OUTPUT_FOLDER=%WORK_FOLDER%"

set "PATH=%IMAGEMAGICK_FOLDER%;%PATH%"

if not exist "%INPUT_FOLDER%" (
    echo Error: Input folder does not exist.
    goto :error
)

echo Input/Output: %WORK_FOLDER%

echo.
echo Input files:
dir /b "%INPUT_FOLDER%"

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
