@echo off
setlocal enabledelayedexpansion
title Auth App - Ejecutar

echo.
echo ============================================================
echo   AUTH APP - Iniciando aplicacion
echo ============================================================
echo.

:: Resolver comando Flutter
set "FLUTTER_CMD="

:: Primero buscar en env\ local (prioritario)
if exist "%~dp0env\flutter\bin\flutter.bat" (
    set "FLUTTER_CMD=%~dp0env\flutter\bin\flutter.bat"
    set "PATH=%~dp0env\flutter\bin;%PATH%"
    echo [OK] Usando Flutter local: env\flutter\
) else (
    where flutter >nul 2>&1
    if !errorlevel! == 0 (
        set "FLUTTER_CMD=flutter"
        echo [OK] Usando Flutter del sistema.
    )
)

if not defined FLUTTER_CMD (
    echo [ERROR] Flutter no esta instalado.
    echo         Ejecuta primero: setup.bat
    echo.
    pause
    exit /b 1
)

cd /d "%~dp0"

:: Verificar que pubspec.yaml existe
if not exist "pubspec.yaml" (
    echo [ERROR] No se encontro pubspec.yaml.
    echo         Asegurate de ejecutar este .bat desde la carpeta del proyecto.
    pause
    exit /b 1
)

:: Verificar que los archivos de plataforma esten generados
if not exist "android" (
    echo [AVISO] Archivos de plataforma no encontrados.
    echo [INFO]  Ejecuta setup.bat primero para generarlos.
    echo.
    pause
    exit /b 1
)

echo [INFO] Dispositivos disponibles:
!FLUTTER_CMD! devices
echo.

:: Preguntar donde correr
echo Selecciona donde correr la app:
echo   [1] Chrome / Web  (recomendado si no hay dispositivo fisico)
echo   [2] Windows Desktop
echo   [3] Dispositivo Android conectado
echo   [4] Elegir automaticamente
echo.
set /p OPCION="Ingresa tu opcion (1-4) [default: 1]: "

if "!OPCION!"=="2" (
    echo [INFO] Corriendo en Windows Desktop...
    !FLUTTER_CMD! run -d windows
) else if "!OPCION!"=="3" (
    echo [INFO] Corriendo en dispositivo Android...
    !FLUTTER_CMD! run -d android
) else if "!OPCION!"=="4" (
    echo [INFO] Eligiendo dispositivo automaticamente...
    !FLUTTER_CMD! run
) else (
    echo [INFO] Corriendo en Chrome...
    !FLUTTER_CMD! run -d chrome
)

echo.
echo [INFO] App detenida.
pause
endlocal
