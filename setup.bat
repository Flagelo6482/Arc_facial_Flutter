@echo off
setlocal enabledelayedexpansion
title Auth App - Setup del Entorno

echo.
echo ============================================================
echo   AUTH APP - Configuracion del Entorno (env)
echo ============================================================
echo.

:: ----------------------------------------------------------
:: 1. Buscar Flutter en PATH del sistema
:: ----------------------------------------------------------
where flutter >nul 2>&1
if %errorlevel% == 0 (
    echo [OK] Flutter encontrado en el PATH del sistema.
    set "FLUTTER_CMD=flutter"
    goto :flutter_ready
)

:: ----------------------------------------------------------
:: 2. Buscar Flutter en la carpeta local env\
:: ----------------------------------------------------------
set "LOCAL_FLUTTER=%~dp0env\flutter\bin\flutter.bat"
if exist "!LOCAL_FLUTTER!" (
    echo [OK] Flutter encontrado en env local: env\flutter\
    set "FLUTTER_CMD=!LOCAL_FLUTTER!"
    set "PATH=%~dp0env\flutter\bin;%PATH%"
    goto :flutter_ready
)

:: ----------------------------------------------------------
:: 3. Intentar instalar con winget (Windows 11 / 10 21H2+)
:: ----------------------------------------------------------
echo [INFO] Flutter no encontrado. Intentando instalar con winget...
winget --version >nul 2>&1
if %errorlevel% == 0 (
    echo [INFO] Instalando Flutter SDK via winget...
    winget install --id Google.Flutter -e --accept-source-agreements --accept-package-agreements
    where flutter >nul 2>&1
    if !errorlevel! == 0 (
        echo [OK] Flutter instalado correctamente via winget.
        set "FLUTTER_CMD=flutter"
        goto :flutter_ready
    )
)

:: ----------------------------------------------------------
:: 4. Descargar Flutter SDK manual en carpeta env\
:: ----------------------------------------------------------
echo [INFO] Descargando Flutter SDK en carpeta env\ (aprox. 700 MB)...
echo [INFO] Por favor espere, esto puede tardar varios minutos...

if not exist "%~dp0env" mkdir "%~dp0env"

powershell -NoProfile -Command ^
  "$ProgressPreference='SilentlyContinue';" ^
  "$url='https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.3-stable.zip';" ^
  "$out='%~dp0env\flutter_sdk.zip';" ^
  "Write-Host '[INFO] Descargando Flutter SDK...';" ^
  "Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing;" ^
  "Write-Host '[INFO] Extrayendo...';" ^
  "Expand-Archive -Path $out -DestinationPath '%~dp0env' -Force;" ^
  "Remove-Item $out;" ^
  "Write-Host '[OK] Flutter SDK listo en env\flutter'"

if exist "%~dp0env\flutter\bin\flutter.bat" (
    set "FLUTTER_CMD=%~dp0env\flutter\bin\flutter.bat"
    set "PATH=%~dp0env\flutter\bin;%PATH%"
    echo [OK] Flutter SDK descargado en env\flutter\
    goto :flutter_ready
) else (
    echo.
    echo [ERROR] No se pudo instalar Flutter automaticamente.
    echo.
    echo  Instala Flutter manualmente:
    echo  1. Ve a: https://flutter.dev/docs/get-started/install/windows
    echo  2. Descarga el SDK y extrae en C:\src\flutter
    echo  3. Agrega C:\src\flutter\bin al PATH de Windows
    echo  4. Vuelve a ejecutar este setup.bat
    echo.
    pause
    exit /b 1
)

:flutter_ready
echo.
echo [INFO] Versiones instaladas:
!FLUTTER_CMD! --version
echo.

:: ----------------------------------------------------------
:: 5. Generar archivos de plataforma con flutter create
:: ----------------------------------------------------------
echo [INFO] Generando archivos de plataforma (Android, Windows, Web)...
cd /d "%~dp0"
!FLUTTER_CMD! create --project-name auth_app --org com.textilesjoc . 2>&1

:: ----------------------------------------------------------
:: 6. Instalar dependencias (flutter pub get)
:: ----------------------------------------------------------
echo.
echo [INFO] Instalando dependencias del proyecto (pubspec.yaml)...
!FLUTTER_CMD! pub get
echo.

:: ----------------------------------------------------------
:: 7. Verificar dispositivos disponibles
:: ----------------------------------------------------------
echo [INFO] Dispositivos disponibles para correr la app:
echo.
!FLUTTER_CMD! devices
echo.

echo ============================================================
echo   Setup completado exitosamente!
echo   Ejecuta run.bat para iniciar la aplicacion.
echo ============================================================
echo.
pause
endlocal
