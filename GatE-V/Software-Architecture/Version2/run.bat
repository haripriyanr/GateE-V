@echo off
setlocal

if /I not "%OS%"=="Windows_NT" (
    echo This script only supports Windows.
    exit /b 1
)

set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo [1/4] Checking for uv...
where uv >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [bootstrap] uv not found. Installing uv...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"
    if %ERRORLEVEL% neq 0 (
        echo Failed to install uv.
        exit /b 1
    )
    set "PATH=%USERPROFILE%\.local\bin;%USERPROFILE%\.cargo\bin;%PATH%"
)

where uv >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo uv is still not available in PATH.
    echo Restart your terminal and run this script again.
    exit /b 1
)

echo [2/4] Ensuring virtual environment exists...
if not exist ".venv" (
    uv venv
    if %ERRORLEVEL% neq 0 (
        echo Failed to create virtual environment.
        exit /b 1
    )
) else (
    echo Reusing existing virtual environment.
)

echo [3/4] Installing dependencies...
uv pip install -r requirements.txt
if %ERRORLEVEL% neq 0 (
    echo Failed to install dependencies.
    exit /b 1
)

echo [4/4] Installing/Verifying PyTorch...
uv run src/main.py --install-torch
if %ERRORLEVEL% neq 0 (
    echo Failed to verify system environment.
    exit /b %ERRORLEVEL%
)

echo Launching GatE-V...
uv run src/main.py

