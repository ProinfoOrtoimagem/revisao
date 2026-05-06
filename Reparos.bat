@echo off
setlocal

:: ******************** VERIFICAR ADMIN ********************
net session >nul 2>&1
if %errorlevel% neq 0 (
    exit /b
)

:: ******************** DISM ********************
echo.
echo [1/3] Executando DISM RestoreHealth...
start /wait DISM /Online /Cleanup-Image /RestoreHealth
if %errorlevel% neq 0 (
    echo ERRO no DISM. Abortando...
    exit /b
)

:: ******************** SFC ********************
echo.
echo [2/3] Executando SFC...
start /wait sfc /scannow
if %errorlevel% neq 0 (
    echo ERRO no SFC. Abortando...
    exit /b
)

:: ******************** CHKDSK ********************
echo.
echo [3/3] Verificando disco (CHKDSK)...
start /wait chkdsk C: /scan
if %errorlevel% neq 0 (
    echo ERRO no CHKDSK. Abortando...
    exit /b
)

echo.
echo Reparo concluido com sucesso.

echo Reiniciando em 10 segundos...
shutdown /r /t 10

exit