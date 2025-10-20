#!/usr/bin/env python3
"""
Ejercicio 9: Analizador de Paquetes ARP
Objetivo: Capturar y analizar trafico ARP, detectar ARP spoofing
NOTA: Requiere permisos de root/administrador
"""

import socket
import struct
import sys
from datetime import datetime
from collections import defaultdict

class AnalizadorARP:
    """Analizador de paquetes ARP"""
    
    # Constantes ARP
    ARP_OPCODE_REQUEST = 1
    ARP_OPCODE_REPLY = 2
    
    def __init__(self, interfaz=None):
        self.interfaz = interfaz
        self.tabla_arp = {}  # {ip: mac}
        self.historial = defaultdict(set)  # {ip: set(macs)}
        self.alertas = []
    
    def crear_socket_raw(self):
        """
        TODO 1: Crear socket raw para capturar paquetes Ethernet
        
        Returns:
            Socket raw configurado
        
        Pista: socket.AF_PACKET para Linux, socket.AF_INET para Windows
        """
        try:
            # TODO: Crear socket raw para recibir todos los paquetes Ethernet
            # En Linux: AF_PACKET, SOCK_RAW, ntohs(0x0003)
            if sys.platform.startswith('linux'):
                sock = socket.socket(
                    socket._______,  # AF_PACKET
                    socket._______,  # SOCK_RAW
                    socket.ntohs(0x0003)  # ETH_P_ALL
                )
            else:
                # En Windows es mas complicado, necesita WinPcap o Npcap
                print("[!] Captura raw no soportada nativamente en Windows")
                print("[!] Usa una libreria como scapy o instala Npcap")
                sys.exit(1)
            
            print("[+] Socket raw creado correctamente")
            return sock
            
        except PermissionError:
            print("[!] ERROR: Se requieren permisos de root")
            print("[!] Ejecuta: sudo python3", sys.argv[0])
            sys.exit(1)
        except Exception as e:
            print(f"[!] Error creando socket: {e}")
            sys.exit(1)
    
    def parsear_ethernet(self, paquete):
        """
        TODO 2: Parsear cabecera Ethernet
        
        Args:
            paquete: Bytes del paquete completo
        
        Returns:
            Tupla (mac_destino, mac_origen, ethertype, payload)
        
        Pista: struct.unpack para parsear binario
        Formato Ethernet: 6 bytes MAC dest, 6 bytes MAC origen, 2 bytes tipo
        """
        # TODO: Extraer primeros 14 bytes (cabecera Ethernet)
        cabecera_eth = paquete[0:__]
        
        # TODO: Parsear cabecera
        # Formato: !6s6sH = 6 bytes MAC dest, 6 bytes MAC origen, 2 bytes tipo
        mac_dest, mac_orig, ethertype = struct.unpack('!______', cabecera_eth)
        
        # Convertir MACs a formato legible
        mac_dest_str = ':'.join(f'{b:02x}' for b in mac_dest)
        mac_orig_str = ':'.join(f'{b:02x}' for b in mac_orig)
        
        # Payload es el resto del paquete
        payload = paquete[14:]
        
        return mac_dest_str, mac_orig_str,