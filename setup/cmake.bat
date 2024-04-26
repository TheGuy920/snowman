@echo off

REM Run CMake to configure the project
cmake -G "Visual Studio 17 2022" -A x64 -S %TMP_MAKE_PATH% -B . ^
         -DCMAKE_TOOLCHAIN_FILE="%VCPKG_DIR%scripts/buildsystems/vcpkg.cmake" ^
         -DCMAKE_C_COMPILER="%VS_PATH%VC/Tools/MSVC/%VS_VERSION%/bin/Hostx64/x64/cl.exe" ^
         -DCMAKE_CXX_COMPILER="%VS_PATH%VC/Tools/MSVC/%VS_VERSION%/bin/Hostx64/x64/cl.exe" ^
         -DIDA_PLUGIN_ENABLED=1 -U IDA_64_BIT_EA_T -DIDA_64_BIT_EA_T=ON