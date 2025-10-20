#!/usr/bin/env python3
"""
Ejercicio 3: Escaner de Red
Objetivo: Escanear una subred y detectar hosts activos
"""

import socket
import ipaddress
import subprocess
import platform
import concurrent.futures
from typing import List, Tuple

def calcular_rango_ips(red: str) -> List[str]:
    """
    TODO 1: Calcula todas las IPs de una subred
    
    Args:
        red: Direccion de red en formato CIDR (ej: "192.168.1.0/24")
    
    Returns:
        Lista de strings con todas las IPs del rango
    
    Pista: Usa ipaddress.ip_network() y itera sobre los hosts

    Bs
    """
    lista_ips = []
    
    # Crear objeto de red
    red_obj = ipaddress.ip_network(________, strict=False)
    
    # Iterar sobre todos los hosts de la red
    for ip in red_obj._________:
        lista_ips.append(str(ip))
    
    return lista_ips


def hacer_ping(ip: str, timeout: int = 1) -> bool:
    """
    TODO 2: Realiza un ping a una IP y devuelve si responde
    
    Args:
        ip: Direccion IP a verificar
        timeout: Tiempo de espera en segundos
    
    Returns:
        True si el host responde, False en caso contrario
    
    Pista: subprocess.run() con diferentes parametros segun el SO
    """
    # Determinar el parametro de count segun el sistema operativo
    param = '-n' if platform.system().lower() == '_______' else '-c'
    
    # Construir el comando ping
    comando = ['ping', param, '1', '-w' if platform.system().lower() == 'windows' else '-W', 
               str(timeout * 1000 if platform.system().lower() == 'windows' else timeout), ip]
    
    try:
        # Ejecutar ping y capturar salida
        resultado = subprocess.run(comando, 
                                  stdout=subprocess._________,
                                  stderr=subprocess._________,
                                  timeout=timeout + 1)
        
        # TODO: Retornar True si el codigo de retorno es 0 (exito)
        return resultado.returncode == ___
    except (subprocess.TimeoutExpired, Exception):
        return False


def resolver_hostname(ip: str) -> str:
    """
    TODO 3: Intenta resolver el nombre DNS de una IP
    
    Args:
        ip: Direccion IP
    
    Returns:
        Nombre del host o "Desconocido" si no se puede resolver
    
    Pista: socket.gethostbyaddr() puede lanzar excepciones
    """
    try:
        # Resolver nombre desde IP
        hostname, _, _ = socket._____________(ip)
        return hostname
    except socket.herror:
        return "Desconocido"
    except Exception:
        return "Error"


def escanear_ip(ip: str) -> Tuple[str, bool, str]:
    """
    Escanea una IP individual
    
    Returns:
        Tupla (ip, esta_activo, hostname)
    """
    activo = hacer_ping(ip)
    hostname = resolver_hostname(ip) if activo else ""
    return (ip, activo, hostname)


def escanear_red(red: str, max_workers: int = 50):
    """
    TODO 4: Escanea toda una subred usando concurrencia
    
    Args:
        red: Red en formato CIDR
        max_workers: Numero maximo de workers concurrentes
    
    Pista: Usa concurrent.futures.ThreadPoolExecutor
    """
    print(f"[*] Escaneando red: {red}")
    print(f"[*] Esto puede tardar unos minutos...\n")
    
    # Calcular rango de IPs
    lista_ips = calcular_rango_ips(red)
    print(f"[*] Total de IPs a escanear: {len(lista_ips)}\n")
    
    hosts_activos = []
    
    # TODO: Usar ThreadPoolExecutor para escanear en paralelo
    with concurrent.futures._____________(max_workers=max_workers) as executor:
        # Enviar todas las tareas
        futuros = {executor.submit(escanear_ip, ip): ip for ip in lista_ips}
        
        # Procesar resultados a medida que se completan
        for i, futuro in enumerate(concurrent.futures.as_completed(futuros), 1):
            ip, activo, hostname = futuro.result()
            
            if activo:
                hosts_activos.append((ip, hostname))
                print(f"[+] Host ACTIVO encontrado: {ip:15} | {hostname}")
            
            # Mostrar progreso cada 10 IPs
            if i % 10 == 0:
                print(f"[*] Progreso: {i}/{len(lista_ips)} IPs escaneadas")
    
    return hosts_activos


def generar_informe(hosts_activos: List[Tuple[str, str]], archivo: str = "informe_red.txt"):
    """
    TODO 5: Genera un informe con los resultados
    
    Args:
        hosts_activos: Lista de tuplas (ip, hostname)
        archivo: Nombre del archivo de salida
    """
    with open(archivo, '________') as f:
        f.write("=" * 60 + "\n")
        f.write("INFORME DE ESCANEO DE RED\n")
        f.write("=" * 60 + "\n\n")
        
        f.write(f"Total de hosts activos: {len(hosts_activos)}\n\n")
        f.write("-" * 60 + "\n")
        f.write(f"{'IP':<15} | {'HOSTNAME'}\n")
        f.write("-" * 60 + "\n")
        
        for ip, hostname in hosts_activos:
            f.write(f"{ip:<15} | {hostname}\n")
        
        f.write("-" * 60 + "\n")
    
    print(f"\n[*] Informe guardado en: {archivo}")


def main():
    """Funcion principal"""
    # TODO 6: Solicitar red al usuario o usar una por defecto
    print("=" * 60)
    print("ESCANER DE RED")
    print("=" * 60)
    print()
    
    # Obtener red a escanear
    red = input("Introduce la red a escanear (ej: 192.168.1.0/24): ").strip()
    
    if not red:
        # Usar red por defecto
        red = "___________________"
        print(f"Usando red por defecto: {red}")
    
    # Validar formato de red
    try:
        ipaddress.ip_network(red, strict=False)
    except ValueError:
        print("[!] ERROR: Formato de red invalido")
        return
    
    # Escanear red
    hosts_activos = escanear_red(red)
    
    # Mostrar resumen
    print("\n" + "=" * 60)
    print(f"RESUMEN: Se encontraron {len(hosts_activos)} hosts activos")
    print("=" * 60)
    
    # Generar informe
    generar_informe(hosts_activos)
    
    print("\n[*] Escaneo completado!")


if __name__ == "__main__":
    main()