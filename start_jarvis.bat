@echo off
title JARVIS - Windows AI CMD Assistant
cd /d "%~dp0"
color 0A

echo.
echo ==========================================
echo         JARVIS - Auto Setup Launcher
echo ==========================================
echo.

:: -------------------------------
:: STEP 1 - Check Python
:: -------------------------------
echo [*] Checking Python installation...
python --version >nul 2>&1

if %ERRORLEVEL% NEQ 0 (
    echo [!] Python not found. Installing Python automatically...
    echo.

    set PYTHON_URL=https://www.python.org/ftp/python/3.11.8/python-3.11.8-amd64.exe
    set PYTHON_INSTALLER=python_installer.exe

    echo [*] Downloading Python...
    powershell -Command "Invoke-WebRequest -Uri %PYTHON_URL% -OutFile %PYTHON_INSTALLER%"

    if not exist %PYTHON_INSTALLER% (
        echo [ERROR] Failed to download Python.
        pause
        exit /b 1
    )

    echo [*] Installing Python silently...
    %PYTHON_INSTALLER% /quiet InstallAllUsers=1 PrependPath=1 Include_test=0

    echo [*] Cleaning installer...
    del %PYTHON_INSTALLER%

    echo [*] Refreshing environment variables...
    setx PATH "%PATH%;C:\Program Files\Python311\;C:\Program Files\Python311\Scripts\"

    echo [✓] Python installation completed.
    echo.
)

:: -------------------------------
:: STEP 2 - Upgrade pip
:: -------------------------------
echo [*] Upgrading pip...
python -m ensurepip --upgrade
python -m pip install --upgrade pip

:: -------------------------------
:: STEP 3 - Install Dependencies
:: -------------------------------
echo [*] Installing project dependencies...
python -m pip install -r requirements.txt

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install dependencies.
    pause
    exit /b 1
)

:: -------------------------------
:: STEP 4 - Launch JARVIS
:: -------------------------------
echo.
echo ==========================================
echo           Launching JARVIS...
echo ==========================================
echo.

python main.py

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [!] JARVIS exited with error code %ERRORLEVEL%
)

pause
exit /b %ERRORLEVEL%
