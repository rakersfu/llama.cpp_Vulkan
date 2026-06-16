markdown
# llama.cpp Vulkan Build Guide (Windows)

本项目说明如何在 **Windows** 环境下使用 **Vulkan 后端** 构建 [llama.cpp](https://github.com/ggml-org/llama.cpp)。

---

## 📦 依赖要求

- **CMake ≥ 3.14**（推荐 3.26+）
- **Visual Studio 2022 Build Tools**（MSVC 编译器）
- **Vulkan SDK**  
  下载并安装 [LunarG Vulkan SDK](https://vulkan.lunarg.com/sdk/home)，并设置环境变量：
  ```cmd
  set VULKAN_SDK=C:\VulkanSDK\1.4.xxx.x
Git（用于拉取源码）

可选依赖：

OpenSSL（启用 HTTPS 支持）

npm（用于构建 Web UI）

⚙️ 构建步骤
克隆源码：

cmd
git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp
运行批处理脚本（示例 build_llama_vulkan.bat）：

bat
@echo off
chcp 65001 >nul

echo ============================================
echo llama.cpp Vulkan Build Script with Proxy Option
echo ============================================

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

cmake -B build -DGGML_VULKAN=1 -G "Visual Studio 17 2022" -A x64
cmake --build build --config Release

echo ============================================
echo Build completed! Executables are in build\bin
echo Examples: llama-cli.exe, llama-server.exe
echo ============================================
pause
构建完成后，主要可执行文件位于：

Code
build\bin\Release\llama-cli.exe
build\bin\Release\llama-server.exe
🔍 验证构建
运行以下命令确认可执行文件正常工作：

cmd
cd build\bin\Release
llama-cli.exe --help
⚠️ 常见问题
UI 构建失败：日志提示 npm not found 或 HuggingFace 下载超时。解决方法：

安装 npm 并重新构建，或

手动下载 llama.cpp release (github.com in Bing) 中的 tools/ui/dist 文件夹。

OpenSSL 未找到：HTTPS 支持被禁用。安装 OpenSSL 并指定路径：

cmd
cmake -B build -DOPENSSL_ROOT_DIR=C:\OpenSSL-Win64
代理问题：脚本支持交互式选择是否启用代理，避免网络下载失败。

📚 参考
llama.cpp 官方仓库

Vulkan SDK 下载

OpenSSL Windows 安装 (slproweb.com in Bing)
