@echo off

REM Check if the vcpkg command is available
vcpkg list >nul 2>&1
if %errorlevel% neq 0 (
    REM Check if the vcpkg folder exists in the workspace
    if exist "%cd%/vcpkg" (
        set "VCPKG_PATH=%cd%/vcpkg/vcpkg.exe"
    ) else (
        REM Clone vcpkg repository
        git clone https://github.com/microsoft/vcpkg.git
        if %errorlevel% neq 0 (
            echo Failed to clone vcpkg repository.
            exit /b 1
        )
        set "VCPKG_PATH=%cd%/vcpkg/vcpkg.exe"
        cd vcpkg
        REM Bootstrap and build vcpkg
        .\bootstrap-vcpkg.bat
        if %errorlevel% neq 0 (
            echo Failed to bootstrap vcpkg.
            exit /b 1
        )
        .\vcpkg integrate install
        if %errorlevel% neq 0 (
            echo Failed to integrate vcpkg.
            exit /b 1
        )
    )
) else (
    REM Find vcpkg path dynamically
    for /f "tokens=*" %%i in ('where vcpkg') do set VCPKG_PATH=%%i
)

REM Get the directory of VCPKG_PATH, removing the filename
for %%a in (%VCPKG_PATH%) do set VCPKG_DIR=%%~dpa
