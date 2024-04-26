@echo off
setlocal

call setup/env-vars.bat

REM Setup Visual Studio Environment
call "%VS_PATH%VC/Auxiliary/Build/vcvars64.bat"

REM Remove the build directory if it exists
if exist build rmdir /s /q build

REM Create a new build directory
mkdir build
cd build

set TMP_MAKE_PATH=../src
call ../setup/cmake.bat

REM Build the project using NMake
cmake --build . --config Release

REM Check if build was successful
if %ERRORLEVEL% neq 0 (
    echo Build failed with errors.
) else (
    echo Build completed successfully.

    REM Copy the contents of build/ida-plugin to IDA_PATH/plugins/snowman (exclude cmake files)
    mkdir "%_IDA_PATH%plugins\snowman"
    mkdir "%_IDA_PATH%plugins\snowman\plugins"

    xcopy .\ida-plugin\build\Release\*.dll "%_IDA_PATH%plugins\snowman" /E /I /Y
    xcopy .\ida-plugin\build\Release\*.conf "%_IDA_PATH%plugins\snowman" /E /I /Y
    xcopy .\ida-plugin\build\Release\plugins\* "%_IDA_PATH%plugins\snowman\plugins" /E /I /Y
)

REM End local environment scope
endlocal

REM close terminal
exit /b %ERRORLEVEL%