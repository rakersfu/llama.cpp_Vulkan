@echo off
chcp 65001 >nul

echo ============================================
echo llama.cpp Vulkan Build Script with Proxy Option
echo ============================================

:: Switch to the directory where this bat file is located
cd /d "%~dp0"

:: Ask user whether to enable proxy
set USE_PROXY=0
set /p ANSWER=Do you want to enable proxy? (Y/N): 

if /I "%ANSWER%"=="Y" (
    set USE_PROXY=1
)

if "%USE_PROXY%"=="1" (
    set HTTP_PROXY=http://192.168.0.107:10808
    set HTTPS_PROXY=http://192.168.0.107:10808
    echo [OK] Proxy enabled: %HTTPS_PROXY%
) else (
    echo [INFO] Proxy disabled
)

:: Check VULKAN_SDK environment variable
if "%VULKAN_SDK%"=="" (
    echo [ERROR] VULKAN_SDK environment variable not detected!
    echo Please install Vulkan SDK and set the environment variable, for example:
    echo   VULKAN_SDK=C:\VulkanSDK\1.4.xxx.x
    pause
    exit /b 1
) else (
    echo [OK] VULKAN_SDK = %VULKAN_SDK%
)

:: Check if glslc.exe exists
if exist "%VULKAN_SDK%\Bin\glslc.exe" (
    echo [OK] Found glslc.exe
) else (
    echo [ERROR] glslc.exe not found, please make sure Vulkan SDK is fully installed!
    pause
    exit /b 1
)

:: Remove old build folder
if exist build (
    echo Cleaning old build folder...
    rmdir /s /q build
)

:: Run CMake configuration
echo Running CMake configuration...
cmake -B build -DGGML_VULKAN=1 -G "Visual Studio 17 2022" -A x64

:: Build project
echo Building project...
cmake --build build --config Release

echo ============================================
echo Build completed! Executables are in build\bin
echo Examples: llama-cli.exe, llama-server.exe
echo ============================================

pause
