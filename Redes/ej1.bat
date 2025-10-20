@echo off
REM ============================================
REM Ejercicio 1: Script de Diagnostico de Red
REM Objetivo: Realizar diagnosticos basicos de red
REM Debes encontrar que comando hace cada cosa en windows y completar los espacios
REM ============================================

echo ========================================
echo DIAGNOSTICO DE RED - WINDOWS
echo ========================================
echo.

REM TODO 1: Mostrar la configuracion IP completa
echo [1] Configuracion IP del equipo:
echo ----------------------------------------
ipconfig ____________
echo.
echo.

REM TODO 2: Obtener el gateway predeterminado y hacer ping
REM Pista: Necesitas extraer la IP del gateway de la salida anterior
REM El gateway suele estar en la linea "Puerta de enlace predeterminada"
echo [2] Probando conectividad con el Gateway:
echo ----------------------------------------
REM Aqui debes hacer ping al gateway (ejemplo: 192.168.1.1)
REM Usa solo 4 paquetes
ping _____ 4 _______________
echo.
echo.

REM TODO 3: Resolver un dominio usando DNS 
echo [3] Resolucion DNS:
echo ----------------------------------------
echo Resolviendo www.google.com...
___________ www.google.com
echo.
echo.

REM TODO 4: Mostrar la tabla ARP
echo [4] Tabla ARP (IP to MAC):
echo ----------------------------------------
arp _____
echo.
echo.

REM TODO 5: Mostrar conexiones de red activas
echo [5] Conexiones de red activas:
echo ----------------------------------------
netstat _____
echo.
echo.

REM TODO 6: Probar conectividad con servidor DNS publico de google
echo [6] Probando DNS de Google (8.8.8.8):
echo ----------------------------------------
ping -n 4 _______________
echo.
echo.

REM TODO 7: Hacer un traceroute a un servidor
echo [7] Trazando ruta a www.upv.es:
echo ----------------------------------------
___________ www.upv.es
echo.
echo.

REM TODO 8: Mostrar estadisticas de protocolos
echo [8] Estadisticas de protocolos:
echo ----------------------------------------
netstat _____
echo.
echo ========================================
echo DIAGNOSTICO COMPLETADO
echo ========================================
pause