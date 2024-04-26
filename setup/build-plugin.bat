@echo off
setlocal

call env-vars.bat

call "%VS_PATH%VC/Auxiliary/Build/vcvars64.bat"

if not exist build (mkdir build)
cd build

REM Remove the build-plugin directory if it exists
if exist ida-plugin rmdir /s /q ida-plugin

REM Create a new build directory
mkdir ida-plugin
cd ida-plugin

set TMP_MAKE_PATH=..\..\src\ida-plugin
call ..\..\cmake.bat

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

    xcopy .\ida-plugin\bin\*.dll "%_IDA_PATH%plugins\snowman" /E /I /Y
    xcopy .\ida-plugin\bin\*.conf "%_IDA_PATH%plugins\snowman" /E /I /Y
    xcopy .\ida-plugin\bin\plugins\* "%_IDA_PATH%plugins\snowman\plugins" /E /I /Y
)

REM End local environment scope
endlocal

REM close terminal
exit /b %ERRORLEVEL%