@echo off
setlocal EnableDelayedExpansion

if /I not "%OS%"=="Windows_NT" (
    echo This script only supports Windows.
    exit /b 1
)

set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "RED=!ESC![0;31m"
set "GREEN=!ESC![0;32m"
set "BLUE=!ESC![0;34m"
set "CYAN=!ESC![0;36m"
set "MAGENTA=!ESC![0;35m"
set "NC=!ESC![0m"

set "DATA_ONLY=false"
set "TRAIN_ONLY=false"
set "FRESH=false"
set "CLEAN_VENV=false"
set "TRAIN_ARGS=--config configs\gatev_v1.0.0.yaml"
set "OVERRIDES="

set "USE_MENU=false"
if "%~1"=="" set "USE_MENU=true"

:parse_args
if "%~1"=="" goto after_parse
if /I "%~1"=="--clean-venv" (
    set "CLEAN_VENV=true"
    shift
    goto parse_args
)
if /I "%~1"=="--data-only" (
    set "DATA_ONLY=true"
    shift
    goto parse_args
)
if /I "%~1"=="--train-only" (
    set "TRAIN_ONLY=true"
    shift
    goto parse_args
)
if /I "%~1"=="--fresh" (
    set "FRESH=true"
    shift
    goto parse_args
)
if /I "%~1"=="--debug" (
    set "OVERRIDES=!OVERRIDES! data.max_samples_debug=100 training.stage1.epochs=2 training.stage2.epochs=2 validation.max_samples_per_task=10"
    shift
    goto parse_args
)
if /I "%~1"=="--no-compile" (
    set "OVERRIDES=!OVERRIDES! training.use_compile=false"
    shift
    goto parse_args
)
if /I "%~1"=="--batch-size" (
    if "%~2"=="" (
        echo --batch-size requires a value
        exit /b 1
    )
    set "OVERRIDES=!OVERRIDES! training.batch_size=%~2"
    shift
    shift
    goto parse_args
)
if /I "%~1"=="--workers" (
    if "%~2"=="" (
        echo --workers requires a value
        exit /b 1
    )
    set "OVERRIDES=!OVERRIDES! data.num_workers=%~2"
    shift
    shift
    goto parse_args
)
echo Unknown option: %~1
echo Usage: run.bat [--data-only] [--train-only] [--fresh] [--clean-venv] [--debug] [--no-compile] [--batch-size N] [--workers N]
exit /b 1

:after_parse

if "%FRESH%"=="true" (
    set "TRAIN_ARGS=%TRAIN_ARGS% --fresh"
)

if not "%OVERRIDES%"=="" (
    set "TRAIN_ARGS=%TRAIN_ARGS% --override %OVERRIDES%"
)

set "DO_SETUP=true"
set "DO_MIRROR=true"
set "DO_DOWNLOAD=true"
set "DO_PRECOMPUTE=true"
set "DO_TRAIN=true"

if /I "%USE_MENU%"=="true" (
    set "DO_MIRROR=false"
    set "DO_DOWNLOAD=false"
    set "DO_PRECOMPUTE=false"
    set "DO_TRAIN=false"
)

if /I "%DATA_ONLY%"=="true" (
    set "DO_TRAIN=false"
)

if /I "%TRAIN_ONLY%"=="true" (
    set "DO_SETUP=false"
    set "DO_MIRROR=false"
    set "DO_DOWNLOAD=false"
    set "DO_PRECOMPUTE=false"
)

if "%DO_SETUP%"=="true" (
    echo.
    echo !MAGENTA!==============================================!NC!
    echo !CYAN!  Environment Setup!NC!
    echo !MAGENTA!==============================================!NC!
    
    where uv >nul 2>&1
    if !ERRORLEVEL! neq 0 (
        echo !BLUE![INFO]!NC! Installing uv...
        powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"
        set "PATH=%USERPROFILE%\.local\bin;%USERPROFILE%\.cargo\bin;%PATH%"
    )

    if "%CLEAN_VENV%"=="true" (
        echo !BLUE![INFO]!NC! Cleaning existing virtual environment...
        if exist ".venv" rmdir /s /q .venv
    )
    if not exist ".venv" (
        echo !BLUE![INFO]!NC! Creating virtual environment...
        uv venv
    )

    echo !BLUE![INFO]!NC! Installing dependencies...
    uv pip install --python .venv\Scripts\python.exe -r requirements.txt

    echo !BLUE![INFO]!NC! Checking Torch installation ^(CPU vs GPU^)...
    .venv\Scripts\python.exe scripts\bootstrap.py --install-torch
    echo !GREEN![SUCCESS]!NC! Environment ready.
)

if "%DO_MIRROR%"=="true" (
    echo.
    echo !MAGENTA!==============================================!NC!
    echo !CYAN!  Mirroring Data!NC!
    echo !MAGENTA!==============================================!NC!
    .venv\Scripts\python.exe scripts\bootstrap.py --mirror-data
)

if "%DO_DOWNLOAD%"=="true" (
    echo.
    echo !MAGENTA!==============================================!NC!
    echo !CYAN!  Downloading COCO images!NC!
    echo !MAGENTA!==============================================!NC!
    .venv\Scripts\python.exe scripts\bootstrap.py --download-images
)

if "%DO_PRECOMPUTE%"=="true" (
    echo.
    echo !MAGENTA!==============================================!NC!
    echo !CYAN!  Precomputing 800px images!NC!
    echo !MAGENTA!==============================================!NC!
    .venv\Scripts\python.exe scripts\bootstrap.py --precompute-images
)

if "%DO_TRAIN%"=="true" (
    echo.
    echo !MAGENTA!==============================================!NC!
    echo !CYAN!  Checking Backbone Model!NC!
    echo !MAGENTA!==============================================!NC!
    if not exist "pretrained\rtdetrv2_r50vd_m_7x_coco_ema.pth" (
        echo !BLUE![INFO]!NC! Downloading RT-DETRv2 ResNet-50vd backbone...
        if not exist "pretrained" mkdir pretrained
        curl -L -o pretrained\rtdetrv2_r50vd_m_7x_coco_ema.pth "https://github.com/lyuwenyu/storage/releases/download/v0.1/rtdetrv2_r50vd_m_7x_coco_ema.pth"
    ) else (
        echo !GREEN![SUCCESS]!NC! Backbone model found locally.
    )

    echo.
    echo !MAGENTA!==============================================!NC!
    echo !CYAN!  Starting training!NC!
    echo !MAGENTA!==============================================!NC!
    if "%FRESH%"=="true" (
        echo !BLUE![INFO]!NC! Deleting previous checkpoints ^(runs\gatev_base\^)...
        if exist "runs\gatev_base" rmdir /s /q runs\gatev_base
    )
    .venv\Scripts\python.exe -u scripts\train.py %TRAIN_ARGS%
)

if "%DATA_ONLY%"=="true" (
    echo !GREEN![SUCCESS]!NC! Data preparation complete. Ready for GPU.
)

if /I "%USE_MENU%"=="true" (
    echo.
    echo !MAGENTA!==============================================!NC!
    echo !CYAN!  Launching Interactive Menu...!NC!
    echo !MAGENTA!==============================================!NC!
    .venv\Scripts\python.exe -u scripts\bootstrap.py
)

exit /b 0
