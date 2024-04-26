@echo off

REM Ensure that vcpkg is available
call setup\vcpkg.bat

REM Install the required packages
del setup\tmp.txt
call %VCPKG_PATH% list qt5-base > setup/tmp.txt
for %%I in ("setup/tmp.txt") do set "FILESIZE=%%~zI"
if "%FILESIZE%"=="0" (
    call %VCPKG_PATH% install qt5-base --recurse
) else (
    echo Qt5 is installed.
)

del setup\tmp.txt
call %VCPKG_PATH% list boost > setup/tmp.txt
for %%I in ("setup/tmp.txt") do set "FILESIZE=%%~zI"
if "%FILESIZE%"=="0" (
    call %VCPKG_PATH% install boost --recurse
) else (
    echo Boost is installed.
)

REM Check if build was successful
if %ERRORLEVEL% neq 0 (
    echo Failed to install required packages.
) else (
    echo Required packages installed successfully.
)