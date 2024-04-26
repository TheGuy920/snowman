@echo off

REM Ensure that vcpkg+requirements is available
call setup/requirements.bat

REM Set environment variables for Visual Studio Version
set VS_VERSION=14.39.33519

goto :main

:validate_input
if not defined tmp_user_input (
    echo No input provided. Exiting.
    exit /b 1
) else (
    set tmp_user_input=%tmp_user_input:/=\%
    if exist "%tmp_user_input%" (
        echo %tmp_user_input%> ".\setup\%~1.cache"
        set %1=%tmp_user_input%
    ) else (
        echo Invalid path.
        set /p tmp_user_input=Enter the path for %1:
        call :validate_input %1
    )
    goto :eof
)

REM Function to check if a directory exists and prompt for it if it doesn't
:check_directory
if not exist %1 (
    if not exist ".\setup\%2.cache" (
        set /p tmp_user_input=Enter the path for %2: 
        call :validate_input %2
        set tmp_user_input=
    ) else (
        for /f "tokens=*" %%a in ('type ".\setup\%2.cache"') do set %2=%%a
    )
    goto :eof
) else (
    set %2=%1
    goto :eof
)

:main
REM Set environment variables for Visual Studio
call :check_directory "%VS_PATH%" VS_PATH

REM Set environment variables for IDA Pro
call :check_directory "%IDA_PATH%" IDA_PATH
set _IDA_PATH=%IDA_PATH:\=/%

REM Print paths for verification/debugging
echo Using Visual Studio at: %VS_PATH%
echo Using IDA Pro at: %IDA_PATH%
echo Using vcpkg at: %VCPKG_DIR%

REM Set environment variables for IDA SDK
set IDA_SDK_DIR=%IDA_PATH%sdk/idasdk77
REM Set environment variables for Qt
set Qt5_DIR=%VCPKG_DIR:/=\%installed/x64-windows/share/cmake/Qt5
set Qt5Core_DIR=%VCPKG_DIR:/=\%installed/x64-windows/share/cmake/Qt5Core
set Qt5Widgets_DIR=%VCPKG_DIR:/=\%installed/x64-windows/share/cmake/Qt5Widgets

:end