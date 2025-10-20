#!/bin/bash
# ============================================
# Ejercicio 6: Simulador de Servidor DHCP
# Objetivo: Simular el proceso DHCP (DORA)
# ============================================

# Archivos de configuracion
LEASES_FILE="dhcp_leases.db"
DEVICES_FILE="devices.txt"
LOG_FILE="dhcp_server.log"

# Configuracion del pool de IPs
NETWORK="192.168.100"
IP_START=10
IP_END=100
GATEWAY="192.168.100.1"
DNS_SERVER="8.8.8.8"
LEASE_TIME=3600  # 1 hora en segundos

# TODO 1: Verificar ejecucion como root
if [ $_____ -ne 0 ]; then
    echo "[ERROR] Este script requiere permisos de root"
    exit 1
fi

# Funcion para logging
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# TODO 2: Inicializar archivos
inicializar() {
    log_message "Inicializando servidor DHCP..."
    
    # Crear archivo de leases si no existe
    if [ ! -f "$LEASES_FILE" ]; then
        touch "$LEASES_FILE"
        log_message "Archivo de leases creado: $LEASES_FILE"
    fi
    
    # Crear archivo de dispositivos de ejemplo si no existe
    if [ ! -f "$DEVICES_FILE" ]; then
        cat > "$DEVICES_FILE" << EOF
00:1A:2B:3C:4D:5E
AA:BB:CC:DD:EE:FF
11:22:33:44:55:66
FF:EE:DD:CC:BB:AA
EOF
        log_message "Archivo de dispositivos creado: $DEVICES_FILE"
    fi
    
    log_message "Servidor DHCP inicializado correctamente"
}

# TODO 3: Obtener siguiente IP disponible del pool
obtener_ip_disponible() {
    local mac=$1
    
    # Verificar si la MAC ya tiene una IP asignada
    local ip_actual=$(grep "^$mac" "$LEASES_FILE" | cut -d'|' -f2)
    
    if [ -n "$ip_actual" ]; then
        echo "$ip_actual"
        return 0
    fi
    
    # Buscar IP disponible en el pool
    for i in $(seq $IP_START $IP_END); do
        local ip="$NETWORK.$i"
        
        # TODO: Verificar si la IP ya esta asignada
        if ! grep -q "|$ip|" "$LEASES_FILE"; then
            echo "$ip"
            return 0
        fi
    done
    
    # No hay IPs disponibles
    echo ""
    return 1
}

# TODO 4: Implementar DHCP DISCOVER
dhcp_discover() {
    local mac=$1
    log_message "========================================="
    log_message "[DHCP DISCOVER] Recibido de MAC: $mac"
    log_message "Cliente solicita configuracion de red"
    
    # Simular un pequeno retardo de red
    sleep 0.5
}

# TODO 5: Implementar DHCP OFFER
dhcp_offer() {
    local mac=$1
    local ip=$(obtener_ip_disponible "$mac")
    
    if [ -z "$ip" ]; then
        log_message "[DHCP OFFER] ERROR: No hay IPs disponibles en el pool"
        return 1
    fi
    
    log_message "[DHCP OFFER] Ofreciendo a $mac:"
    log_message "  - IP: $ip"
    log_message "  - Mascara: _______________"  # TODO: Completar
    log_message "  - Gateway: $GATEWAY"
    log_message "  - DNS: $DNS_SERVER"
    log_message "  - Lease time: $LEASE_TIME segundos"
    
    echo "$ip"
    sleep 0.5
}

# TODO 6: Implementar DHCP REQUEST
dhcp_request() {
    local mac=$1
    local ip=$2
    
    log_message "[DHCP REQUEST] Cliente $mac solicita IP $ip"
    log_message "Cliente acepta la configuracion ofrecida"
    
    sleep 0.5
}

# TODO 7: Implementar DHCP ACK
dhcp_ack() {
    local mac=$1
    local ip=$2
    local timestamp=$(date +%s)
    local expire_time=$((timestamp + LEASE_TIME))
    
    log_message "[DHCP ACK] Confirmando asignacion:"
    log_message "  - MAC: $mac"
    log_message "  - IP: $ip"
    log_message "  - Expira: $(date -d @$expire_time '+%Y-%m-%d %H:%M:%S')"
    
    # TODO: Guardar lease en archivo
    # Formato: MAC|IP|TIMESTAMP|EXPIRE_TIME
    echo "$mac|$ip|$timestamp|$expire_time" >> "$LEASES_FILE"
    
    log_message "[DHCP ACK] Asignacion completada exitosamente"
}

# TODO 8: Proceso DORA completo
proceso_dora() {
    local mac=$1
    
    log_message ""
    log_message "========================================="
    log_message "INICIANDO PROCESO DORA PARA MAC: $mac"
    log_message "========================================="
    
    # DISCOVER
    dhcp_discover "$mac"
    
    # OFFER
    local ip=$(dhcp_offer "$mac")
    if [ -z "$ip" ]; then
        log_message "[ERROR] No se pudo completar el proceso DORA"
        return 1
    fi
    
    # REQUEST
    dhcp_request "$mac" "$ip"
    
    # ACK
    dhcp_ack "$mac" "$ip"
    
    log_message "========================================="
    log_message "PROCESO DORA COMPLETADO"
    log_message "========================================="
    log_message ""
}

# TODO 9: Renovar lease
renovar_lease() {
    local mac=$1
    
    log_message "[RENOVACION] Solicitud de renovacion de $mac"
    
    # Buscar lease actual
    local lease=$(grep "^$mac" "$LEASES_FILE" | tail -1)
    
    if [ -z "$lease" ]; then
        log_message "[ERROR] No se encontro lease activo para $mac"
        return 1
    fi
    
    local ip=$(echo "$lease" | cut -d'|' -f2)
    
    # TODO: Eliminar lease antiguo
    sed -i "/^$mac|/d" "$LEASES_FILE"
    
    # Crear nuevo lease
    dhcp_ack "$mac" "$ip"
    
    log_message "[RENOVACION] Lease renovado exitosamente"
}

# TODO 10: Liberar IP
liberar_ip() {
    local mac=$1
    
    log_message "[RELEASE] Cliente $mac libera su IP"
    
    # TODO: Eliminar del archivo de leases
    local ip=$(grep "^$mac" "$LEASES_FILE" | cut -d'|' -f2)
    sed -i "/^$mac|/d" "$__________"
    
    log_message "[RELEASE] IP $ip liberada y disponible en el pool"
}

# TODO 11: Mostrar leases activos
mostrar_leases() {
    echo ""
    echo "========================================="
    echo "LEASES ACTIVOS"
    echo "========================================="
    echo ""
    
    if [ ! -s "$LEASES_FILE" ]; then
        echo "No hay leases activos"
        return
    fi
    
    printf "%-20s %-15s %-20s %-20s\n" "MAC" "IP" "ASIGNADO" "EXPIRA"
    echo "---------------------------------------------------------------------------------------------------------"
    
    while IFS='|' read -r mac ip timestamp expire; do
        local asignado=$(date -d @$timestamp '+%Y-%m-%d %H:%M:%S')
        local expira=$(date -d @$expire '+%Y-%m-%d %H:%M:%S')
        printf "%-20s %-15s %-20s %-20s\n" "$mac" "$ip" "$asignado" "$expira"
    done < "$LEASES_FILE"
    
    echo ""
}

# TODO 12: Limpiar leases expirados
limpiar_expirados() {
    local ahora=$(date +%s)
    local count=0
    
    log_message "[LIMPIEZA] Verificando leases expirados..."
    
    # Leer archivo temporal
    while IFS='|' read -r mac ip timestamp expire; do
        if [ "$expire" -gt "$ahora" ]; then
            # Lease todavia valido
            echo "$mac|$ip|$timestamp|$expire"
        else
            # Lease expirado
            log_message "[LIMPIEZA] Lease expirado: $mac - $ip"
            ((count++))
        fi
    done < "$LEASES_FILE" > "$LEASES_FILE.tmp"
    
    mv "$LEASES_FILE.tmp" "$LEASES_FILE"
    
    log_message "[LIMPIEZA] $count leases expirados eliminados"
}

# Menu principal
menu() {
    while true; do
        echo ""
        echo "========================================="
        echo "SERVIDOR DHCP SIMULADO"
        echo "========================================="
        echo "1. Simular peticion DHCP (DORA)"
        echo "2. Renovar lease"
        echo "3. Liberar IP"
        echo "4. Mostrar leases activos"
        echo "5. Limpiar leases expirados"
        echo "6. Procesar todos los dispositivos"
        echo "7. Salir"
        echo "========================================="
        read -p "Selecciona una opcion: " opcion
        
        case $opcion in
            1)
                read -p "Introduce la MAC (formato XX:XX:XX:XX:XX:XX): " mac
                proceso_dora "$mac"
                ;;
            2)
                read -p "Introduce la MAC a renovar: " mac
                renovar_lease "$mac"
                ;;
            3)
                read -p "Introduce la MAC a liberar: " mac
                liberar_ip "$mac"
                ;;
            4)
                mostrar_leases
                ;;
            5)
                limpiar_expirados
                ;;
            6)
                while read -r mac; do
                    proceso_dora "$mac"
                    sleep 1
                done < "$DEVICES_FILE"
                ;;
            7)
                log_message "Servidor DHCP detenido"
                exit 0
                ;;
            *)
                echo "[ERROR] Opcion invalida"
                ;;
        esac
    done
}

# Programa principal
main() {
    clear
    inicializar
    menu
}

main