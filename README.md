# llama.cpp Vulkan 构建指南 (Windows)

本项目说明如何在 **Windows** 环境下使用 **Vulkan 后端** 构建 [llama.cpp](https://github.com/ggml-org/llama.cpp)。

---

## 📦 依赖要求

### 必需依赖

| 依赖项 | 版本要求 | 说明 |
|------|--------|------|
| CMake | ≥ 3.14（推荐 3.26+） | 构建系统 |
| Visual Studio 2022 Build Tools | 最新版 | MSVC 编译器 |
| Vulkan SDK | LunarG 最新版 | GPU 计算库 |
| Git | 最新版 | 源码控制 |

### 可选依赖

| 依赖项 | 用途 |
|------|------|
| OpenSSL | 启用 HTTPS 支持 |
| npm | 构建 Web UI |

### Vulkan SDK 安装

1. 下载并安装 [LunarG Vulkan SDK](https://vulkan.lunarg.com/sdk/home)
2. 设置环境变量：
   ```cmd
   set VULKAN_SDK=C:\VulkanSDK\1.4.xxx.x
   ```

---

## ⚙️ 构建步骤

### 1. 克隆源码

```cmd
git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp
```

### 2. 构建脚本

创建 `build_llama_vulkan.bat` 文件，内容如下：

```batch
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
```

### 3. 执行构建

```cmd
build_llama_vulkan.bat
```

### 4. 构建输出

构建完成后，主要可执行文件位于：

```
build\bin\Release\llama-cli.exe
build\bin\Release\llama-server.exe
```

---

## 🔍 验证构建

运行以下命令确认可执行文件正常工作：

```cmd
cd build\bin\Release
llama-cli.exe --help
```

---

## ⚠️ 常见问题

### 问题 1：UI 构建失败

**症状：** 日志提示 `npm not found` 或 `HuggingFace 下载超时`

**解决方案：**
- 安装 npm 并重新构建，或
- 手动下载 [llama.cpp release](https://github.com/ggml-org/llama.cpp/releases) 中的 `tools/ui/dist` 文件夹

### 问题 2：OpenSSL 未找到

**症状：** HTTPS 支持被禁用，构建警告

**解决方案：** 安装 OpenSSL 并指定路径：

```cmd
cmake -B build -DGGML_VULKAN=1 -DOPENSSL_ROOT_DIR=C:\OpenSSL-Win64 -G "Visual Studio 17 2022" -A x64
```

### 问题 3：代理网络问题

**症状：** 网络下载失败或超时

**解决方案：** 构建脚本支持交互式代理配置，根据提示启用代理即可，请注意修改.bat中的代理地址，根据自身情况修改。

---

## 📚 参考资源

- [llama.cpp 官方仓库](https://github.com/ggml-org/llama.cpp)
- [Vulkan SDK 下载](https://vulkan.lunarg.com/sdk/home)
- [OpenSSL Windows 安装](https://slproweb.com)

---

## 💡 快速命令参考

```cmd
# 仅编译 Vulkan 支持
cmake -B build -DGGML_VULKAN=1 -G "Visual Studio 17 2022" -A x64

# 编译 + OpenSSL 支持
cmake -B build -DGGML_VULKAN=1 -DOPENSSL_ROOT_DIR=C:\OpenSSL-Win64 -G "Visual Studio 17 2022" -A x64

# 构建项目
cmake --build build --config Release

# 清除构建
rmdir /s /q build
```
