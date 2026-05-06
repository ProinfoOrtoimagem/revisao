@echo off
setlocal

:: ******************** VERIFICAR ADMIN ********************
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Execute este script como ADMINISTRADOR.
    pause
    exit
)

:: ******************** LOG ********************
set LOG=C:\reparo_windows.log
echo Iniciando reparo em %date% %time% > %LOG%

:: ******************** DISM ********************
echo.
echo [1/3] Executando DISM RestoreHealth...
echo [1/3] DISM RestoreHealth... >> %LOG%
DISM /Online /Cleanup-Image /RestoreHealth >> %LOG% 2>&1

:: ******************** SFC ********************
echo.
echo [2/3] Executando SFC...
echo [2/3] SFC Scan... >> %LOG%
sfc /scannow >> %LOG% 2>&1

:: ******************** CHKDSK ********************
echo.
echo [3/3] Verificando disco (CHKDSK)...
echo [3/3] CHKDSK Scan... >> %LOG%
chkdsk C: /scan >> %LOG% 2>&1

:: ******************** FINAL ********************
echo.
echo Reparo concluido.
echo Verifique o log em: %LOG%
echo.

echo Recomenda-se REINICIAR o computador antes de rodar a limpeza.

:: ******************** AGENDAR LIMPEZA ********************
set CLEAN_SCRIPT=C:\revisao\Script Limpeza.bat

echo Agendando limpeza para proximo boot... >> %LOG%

schtasks /create ^
 /tn "LimpezaPosReparo" ^
 /tr "\"%CLEAN_SCRIPT%\"" ^
 /sc onlogon ^
 /rl HIGHEST ^
 /f >> %LOG% 2>&1

:: ******************** FINAL ********************
echo Reparo concluido >> %LOG%

echo Reiniciando em 10 segundos...
shutdown /r /t 10

exit