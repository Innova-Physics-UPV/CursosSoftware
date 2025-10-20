@echo off
REM ============================================
REM Ejercicio 5: Monitor de Trafico de Red
REM Objetivo: Monitorear conexiones y generar estadisticas
REM ============================================

setlocal enabledelayedexpansion

REM Configuracion
set INTERVALO=5
set LOG_FILE=trafico_red_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log
set LOG_FILE=%LOG_FILE: =0%
set CONTADOR=0

echo ========================================
echo MONITOR DE TRAFICO DE RED
echo ========================================
echo.
echo Archivo de log: %LOG_FILE%
echo Intervalo de captura: %INTERVALO% segundos
echo Presiona Ctrl+C para detener
echo.
echo ========================================
echo.

REM Inicializar archivo de log
echo ======================================== > %LOG_FILE%
echo MONITOR DE TRAFICO DE RED >> %LOG_FILE%
echo Inicio: %date% %time% >> %LOG_FILE%
echo ======================================== >> %LOG_FILE%
echo. >> %LOG_FILE%

:LOOP
set /a CONTADOR+=1

echo [%date% %time%] Captura #%CONTADOR%
echo. >> %LOG_FILE%
echo ---------------------------------------- >> %LOG_FILE%
echo Captura #%CONTADOR% - %date% %time% >> %LOG_FILE%
echo ---------------------------------------- >> %LOG_FILE%

REM TODO 1: Capturar todas las conexiones TCP activas
REM Pista: netstat con parametros para mostrar TCP, numerico y PID
echo. >> %LOG_FILE%
echo [CONEXIONES TCP ACTIVAS] >> %LOG_FILE%
netstat ________ >> %LOG_FILE%

REM TODO 2: Capturar estadisticas de protocolos
REM Pista: netstat con parametro para estadisticas
echo. >> %LOG_FILE%
echo [ESTADISTICAS DE PROTOCOLOS] >> %LOG_FILE%
netstat _____ >> %LOG_FILE%

REM TODO 3: Contar conexiones por estado
REM Pista: findstr para filtrar y contar lineas
echo. >> %LOG_FILE%
echo [RESUMEN POR ESTADO] >> %LOG_FILE%

REM Contar ESTABLISHED
for /f %%a in ('netstat -an ^| findstr "___________" ^| find /c /v ""') do set COUNT_EST=%%a
echo ESTABLISHED: !COUNT_EST! >> %LOG_FILE%

REM TODO: Completar para otros estados
for /f %%a in ('netstat -an ^| findstr "___________" ^| find /c /v ""') do set COUNT_LISTEN=%%a
echo LISTENING: !COUNT_LISTEN! >> %LOG_FILE%

for /f %%a in ('netstat -an ^| findstr "___________" ^| find /c /v ""') do set COUNT_WAIT=%%a
echo TIME_WAIT: !COUNT_WAIT! >> %LOG_FILE%

REM TODO 4: Listar top 5 IPs con mas conexiones
echo. >> %LOG_FILE%
echo [TOP 5 IPs MAS CONECTADAS] >> %LOG_FILE%

REM Obtener IPs remotas y contarlas
REM Esto es complejo en batch, aqui una version simplificada
netstat -an | findstr "ESTABLISHED" | findstr /v "127.0.0.1" >> %LOG_FILE%

REM TODO 5: Mostrar conexiones a puertos especificos (HTTP, HTTPS, DNS)
echo. >> %LOG_FILE%
echo [CONEXIONES A SERVICIOS CONOCIDOS] >> %LOG_FILE%

REM HTTP (puerto 80)
for /f %%a in ('netstat -an ^| findstr ":___" ^| find /c /v ""') do set COUNT_HTTP=%%a
echo HTTP (80): !COUNT_HTTP! conexiones >> %LOG_FILE%

REM HTTPS (puerto 443)
for /f %%a in ('netstat -an ^| findstr ":____" ^| find /c /v ""') do set COUNT_HTTPS=%%a
echo HTTPS (443): !COUNT_HTTPS! conexiones >> %LOG_FILE%

REM DNS (puerto 53)
for /f %%a in ('netstat -an ^| findstr ":___" ^| find /c /v ""') do set COUNT_DNS=%%a
echo DNS (53): !COUNT_DNS! conexiones >> %LOG_FILE%

REM TODO 6: Capturar uso de ancho de banda (requiere herramientas adicionales)
REM En Windows nativo es limitado, aqui mostramos interfaces activas
echo. >> %LOG_FILE%
echo [INTERFACES DE RED] >> %LOG_FILE%
ipconfig | findstr /C:"Ethernet" /C:"IPv4" >> %LOG_FILE%

REM Resumen en pantalla
echo [+] Captura #%CONTADOR% completada
echo     - Conexiones ESTABLISHED: !COUNT_EST!
echo     - Conexiones LISTENING: !COUNT_LISTEN!
echo     - Conexiones HTTP: !COUNT_HTTP!
echo     - Conexiones HTTPS: !COUNT_HTTPS!
echo.

REM TODO 7: Detectar posibles anomalias
REM Si hay mas de 100 conexiones ESTABLISHED, alertar
if !COUNT_EST! GTR 100 (
    echo. >> %LOG_FILE%
    echo [ALERTA] Numero inusual de conexiones ESTABLISHED: !COUNT_EST! >> %LOG_FILE%
    echo [ALERTA] Demasiadas conexiones ESTABLISHED: !COUNT_EST!
)

REM Esperar antes de la siguiente captura
timeout /t %INTERVALO% /nobreak > nul

goto LOOP

endlocal