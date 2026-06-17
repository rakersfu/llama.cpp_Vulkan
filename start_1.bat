@echo off
:: Enable delayed expansion for variables inside loops
setlocal enabledelayedexpansion

:: Change to script directory (llama.cpp root)
cd /d "%~dp0"

:: ==========================================
:: List all GGUF models in models directory
:: ==========================================
echo Available models:
set INDEX=0
for %%F in ("%~dp0models\*.gguf") do (
    set /a INDEX+=1
    echo !INDEX!: %%~nxF
    set MODEL_!INDEX!=%%F
)

:: ==========================================
:: Ask user to choose a model
:: ==========================================
set /p CHOICE=Enter the number of the model you want to load: 

:: Match choice with model
set SELECTED_MODEL=
for /l %%I in (1,1,!INDEX!) do (
    if "!CHOICE!"=="%%I" (
        set SELECTED_MODEL=!MODEL_%%I!
    )
)

if not defined SELECTED_MODEL (
    echo Invalid choice. Exiting...
    pause
    exit /b
)

echo You selected: %SELECTED_MODEL%

:: ==========================================
:: Detect GPU memory and set n-gpu-layers
:: ==========================================
set NLAYERS=20
set MEMFREE=

:: Use full path to nvidia-smi if needed
set NVSmiPath="C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe"

:: Capture only the first numeric line
for /f "usebackq tokens=* delims=" %%A in (`%NVSmiPath% --query-gpu=memory.free --format=csv,noheader,nounits 2^>nul`) do (
    set MEMFREE=%%A
    goto :gotmem
)
:gotmem

if not defined MEMFREE (
    set MEMFREE=0
    set NLAYERS=0
)

if %MEMFREE% GEQ 6000 (
    set NLAYERS=40
) else if %MEMFREE% GEQ 4000 (
    set NLAYERS=20
) else (
    set NLAYERS=0
)

echo Free GPU memory: %MEMFREE% MiB
echo Using --n-gpu-layers %NLAYERS%

:: ==========================================
:: Launch llama-server with selected model
:: ==========================================
echo Starting llama-server...
echo ------------------------------------------
"%~dp0build\bin\Release\llama-server.exe" ^
  -m "%SELECTED_MODEL%" ^
  --ctx-size 16384 ^
  --n-gpu-layers %NLAYERS% ^
  --no-mmap ^
  -fa on ^
  --cache-type-k q8_0 --cache-type-v q8_0 ^
  --temp 1.0 --top-p 0.95 --top-k 64 ^
  --host 0.0.0.0 --port 18080 ^
  -fit off

echo ------------------------------------------
echo llama-server exited. Press any key to close.
pause
