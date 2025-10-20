#!/bin/bash
# ============================================
# Ejercicio 2: Script de Configuracion de Red
# Objetivo: Configurar interfaz de red en Linux
# ============================================

echo "========================================"
echo "CONFIGURACION DE RED - LINUX"
echo "========================================"
echo

# TODO 1: Verificar que se ejecuta como root
if [ $_____ -ne 0 ]; then
    echo "ERROR: Este script debe ejecutarse como root"
    echo "Usa: sudo $0"
    exit 1
fi

echo "[1] Usuario verificado: ROOT"
echo

# TODO 2: Mostrar todas las interfaces de red
echo "[2] Interfaces de red disponibles:"
echo "----------------------------------------"
ip __________ show
echo
echo

# Variables de configuracion
INTERFACE="eth0"  # Cambiar segun tu interfaz
IP_ADDRESS="192.168.100.50"
NETMASK="24"  # Notacion CIDR
GATEWAY="192.168.100.1"

echo "[3] Configurando interfaz $INTERFACE..."
echo "----------------------------------------"

# TODO 3: Levantar la interfaz (activarla)
#Buscar opción correcta para activar la interfaz
ip link set $INTERFACE _____
echo "Interfaz $INTERFACE activada"
echo

# TODO 4: Asignar direccion IP a la interfaz
#Bucar opción correcta para asignar la IP
echo "[4] Asignando IP ${IP_ADDRESS}/${NETMASK}..."
ip addr add _____________________ dev $INTERFACE
echo "IP asignada correctamente"
echo

# TODO 5: Configurar puerta de enlace predeterminada
#Bucar opción correcta para agregar la ruta por defecto
echo "[5] Configurando gateway ${GATEWAY}..."
ip route add __________ via $GATEWAY
echo "Gateway configurado"
echo

# TODO 6: Mostrar la configuracion actual de la interfaz
# Buscar opción correcta para mostrar detalles de la interfaz
echo "[6] Configuracion actual de $INTERFACE:"
echo "----------------------------------------"
ip addr show ___________
echo
echo

# TODO 7: Mostrar tabla de rutas
#Buscar opción correcta para mostrar la tabla de rutas
echo "[7] Tabla de rutas:"
echo "----------------------------------------"
ip __________ show
echo
echo

# TODO 8: Probar conectividad con el gateway
#Buscar opción correcta para cantidad de paquetes de ping
echo "[8] Probando conectividad con gateway..."
echo "----------------------------------------"
ping _____ 4 $GATEWAY
echo

# TODO 9: Verificar resolucion DNS
# Comando para resolver un dominio (se parece en windows)
echo "[9] Probando resolucion DNS..."
echo "----------------------------------------"
_____ www.google.com
echo

# TODO 10: Mostrar tabla ARP
# Pista: ip neigh show (o arp -a)
echo "[10] Tabla ARP:"
echo "----------------------------------------"
ip __________ show
echo

echo "========================================"
echo "CONFIGURACION COMPLETADA"
echo "========================================"