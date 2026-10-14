@echo off
setlocal
cd /d "%~dp0"
title God's Eye View

set "GEV_URL=http://localhost:4173/"

rem Already running? Open it and stop here.
powershell -NoProfile -Command "try { Invoke-WebRequest -UseBasicParsing -Uri '%GEV_URL%' -TimeoutSec 3 | Out-Null; exit 0 } catch { exit 1 }" >nul 2>&1
if not errorlevel 1 goto open

echo.
echo   Iniciando o God's Eye View...
echo   (a janela do servidor fica aberta enquanto o app estiver rodando)
echo.

start "God's Eye View - servidor" /min cmd /c "npm run dev"

echo   Aguardando o globo carregar...
powershell -NoProfile -Command "$u='%GEV_URL%'; for ($i=0; $i -lt 120; $i++) { try { Invoke-WebRequest -UseBasicParsing -Uri $u -TimeoutSec 2 | Out-Null; exit 0 } catch { Start-Sleep -Milliseconds 1000 } }; exit 1"
if errorlevel 1 (
  echo.
  echo   Nao foi possivel iniciar o servidor.
  echo   Verifique a janela "God's Eye View - servidor" e se o Node.js 24 esta instalado.
  echo.
  pause
  exit /b 1
)

:open
start "" "%GEV_URL%"
exit /b 0
