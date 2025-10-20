#!/usr/bin/env python3
"""
Ejercicio 7: Cliente HTTP/HTTPS
Objetivo: Implementar cliente HTTP con soporte SSL/TLS
"""

import socket
import ssl
import urllib.parse
from typing import Dict, Tuple, Optional

class ClienteHTTP:
    """Cliente HTTP/HTTPS personalizado"""
    
    def __init__(self, timeout: int = 10):
        self.timeout = timeout
        self.cookies = {}
    
    def parsear_url(self, url: str) -> Dict[str, str]:
        """
        TODO 1: Parsear una URL y extraer sus componentes
        
        Args:
            url: URL completa (ej: https://www.example.com:443/path?query=value)
        
        Returns:
            Diccionario con scheme, host, port, path, query
        
        Pista: Usa urllib.parse.urlparse
        """
        # TODO: Parsear URL
        parsed = urllib.parse._________(url)
        
        # Determinar esquema (http o https)
        scheme = parsed.scheme if parsed.scheme else '_____'
        
        # Determinar puerto por defecto
        if parsed.port:
            port = parsed.port
        else:
            # TODO: Asignar puerto segun el esquema
            port = 443 if scheme == '______' else 80
        
        # Construir path completo con query
        path = parsed.path if parsed.path else '/'
        if parsed.query:
            path += '?' + parsed.query
        
        return {
            'scheme': scheme,
            'host': parsed.hostname,
            'port': port,
            'path': path
        }
    
    def crear_peticion_http(self, metodo: str, host: str, path: str, 
                           headers: Optional[Dict] = None) -> str:
        """
        TODO 2: Construir una peticion HTTP valida
        
        Args:
            metodo: GET, POST, etc.
            host: Nombre del host
            path: Ruta del recurso
            headers: Cabeceras adicionales
        
        Returns:
            String con la peticion HTTP completa
        
        Pista: Formato HTTP: METODO PATH HTTP/1.1\r\nHeader: Value\r\n\r\n
        """
        # TODO: Construir linea de peticion
        peticion = f"{metodo} {path} HTTP/___\r\n"
        
        # TODO: Añadir cabecera Host (obligatoria en HTTP/1.1)
        peticion += f"Host: {_____}\r\n"
        
        # Cabeceras por defecto
        peticion += "User-Agent: ClienteHTTP-Python/1.0\r\n"
        peticion += "Accept: */*\r\n"
        peticion += "Connection: close\r\n"
        
        # Añadir cookies si existen
        if self.cookies:
            cookie_str = '; '.join([f"{k}={v}" for k, v in self.cookies.items()])
            peticion += f"Cookie: {cookie_str}\r\n"
        
        # TODO: Añadir cabeceras adicionales
        if headers:
            for key, value in headers.items():
                peticion += f"{key}: {value}\r\n"
        
        # TODO: Linea vacia que marca el fin de las cabeceras
        peticion += "____"
        
        return peticion
    
    def parsear_respuesta(self, respuesta: bytes) -> Tuple[int, Dict, bytes]:
        """
        TODO 3: Parsear respuesta HTTP
        
        Args:
            respuesta: Respuesta completa en bytes
        
        Returns:
            Tupla (codigo_estado, cabeceras, cuerpo)
        
        Pista: Separar cabeceras del cuerpo con \r\n\r\n
        """
        # TODO: Separar cabeceras del cuerpo
        partes = respuesta.split(b'______', 1)
        
        if len(partes) != 2:
            return 0, {}, respuesta
        
        cabeceras_raw, cuerpo = partes
        lineas = cabeceras_raw.decode('utf-8', errors='ignore').split('\r\n')
        
        # TODO: Extraer codigo de estado de la primera linea
        # Formato: HTTP/1.1 200 OK
        primera_linea = lineas[0].split()
        codigo_estado = int(primera_linea[___]) if len(primera_linea) >= 2 else 0
        
        # Parsear cabeceras
        cabeceras = {}
        for linea in lineas[1:]:
            if ':' in linea:
                key, value = linea.split(':', 1)
                cabeceras[key.strip().lower()] = value.strip()
        
        # TODO: Extraer cookies si existen
        if 'set-cookie' in cabeceras:
            cookie_parts = cabeceras['set-cookie'].split(';')[0].split('=', 1)
            if len(cookie_parts) == 2:
                self.cookies[cookie_parts[0]] = cookie_parts[1]
        
        return codigo_estado, cabeceras, cuerpo
    
    def conectar_socket(self, host: str, port: int, usar_ssl: bool) -> socket.socket:
        """
        TODO 4: Crear y conectar socket (con SSL si es necesario)
        
        Args:
            host: Hostname
            port: Puerto
            usar_ssl: True para HTTPS, False para HTTP
        
        Returns:
            Socket conectado (con SSL si corresponde)
        
        Pista: ssl.wrap_socket() para HTTPS
        """
        # TODO: Crear socket TCP
        sock = socket.socket(socket._______, socket.__________)
        sock.settimeout(self.timeout)
        
        print(f"[*] Conectando a {host}:{port}...")
        
        # TODO: Conectar al servidor
        sock.________((____, port))
        
        print(f"[+] Conexion TCP establecida")
        
        # TODO: Si es HTTPS, envolver socket con SSL/TLS
        if usar_ssl:
            print("[*] Iniciando handshake TLS/SSL...")
            
            # Crear contexto SSL
            context = ssl.create_default_context()
            
            # TODO: Envolver socket con SSL
            sock = context._________(sock, server_hostname=host)
            
            print(f"[+] Conexion segura establecida")
            print(f"    - Protocolo: {sock.version()}")
            print(f"    - Cifrado: {sock.cipher()}")
            
            # TODO: Verificar certificado
            cert = sock.getpeercert()
            if cert:
                print(f"[+] Certificado verificado para: {host}")
        
        return sock
    
    def realizar_peticion(self, url: str, metodo: str = "GET", 
                         headers: Optional[Dict] = None) -> Tuple[int, Dict, bytes]:
        """
        TODO 5: Realizar peticion HTTP/HTTPS completa
        
        Args:
            url: URL completa
            metodo: Metodo HTTP (GET, POST, etc.)
            headers: Cabeceras adicionales
        
        Returns:
            Tupla (codigo_estado, cabeceras, cuerpo)
        """
        # Parsear URL
        componentes = self.parsear_url(url)
        
        print(f"\n[*] Peticion {metodo} a {url}")
        print(f"    - Scheme: {componentes['scheme']}")
        print(f"    - Host: {componentes['host']}")
        print(f"    - Port: {componentes['port']}")
        print(f"    - Path: {componentes['path']}")
        
        # Determinar si usar SSL
        usar_ssl = componentes['scheme'] == '_______'
        
        # TODO: Conectar al servidor
        sock = self.conectar_socket(
            componentes['host'], 
            componentes['port'], 
            usar_ssl
        )
        
        try:
            # TODO: Construir peticion HTTP
            peticion = self.crear_peticion_http(
                metodo,
                componentes['host'],
                componentes['path'],
                headers
            )
            
            print(f"\n[>] Enviando peticion:")
            print("=" * 50)
            print(peticion)
            print("=" * 50)
            
            # TODO: Enviar peticion
            sock._______(peticion.encode('utf-8'))
            
            # TODO: Recibir respuesta
            respuesta = b''
            while True:
                chunk = sock.recv(4096)
                if not chunk:
                    break
                respuesta += chunk
            
            print(f"\n[<] Respuesta recibida ({len(respuesta)} bytes)")
            
            # TODO: Parsear respuesta
            codigo, cabeceras, cuerpo = self.parsear_respuesta(respuesta)
            
            print(f"[+] Codigo de estado: {codigo}")
            print(f"[+] Cabeceras recibidas: {len(cabeceras)}")
            
            return codigo, cabeceras, cuerpo
            
        finally:
            sock.close()
            print("[*] Conexion cerrada")
    
    def seguir_redirecciones(self, url: str, max_redirecciones: int = 5) -> Tuple[int, Dict, bytes]:
        """
        TODO 6: Seguir redirecciones HTTP (301, 302, etc.)
        
        Args:
            url: URL inicial
            max_redirecciones: Maximo numero de redirecciones a seguir
        
        Returns:
            Respuesta final
        
        Pista: Codigos 3xx indican redireccion
        """
        url_actual = url
        
        for i in range(max_redirecciones):
            codigo, cabeceras, cuerpo = self.realizar_peticion(url_actual)
            
            # TODO: Verificar si es una redireccion (codigos 3xx)
            if 300 <= codigo < 400:
                # TODO: Obtener URL de redireccion de las cabeceras
                if '________' in cabeceras:
                    url_actual = cabeceras['location']
                    print(f"\n[->] Redireccion #{i+1} a: {url_actual}")
                    continue
                else:
                    print("[!] Codigo de redireccion pero sin cabecera Location")
                    break
            else:
                # No es redireccion, retornar respuesta
                return codigo, cabeceras, cuerpo
        
        print(f"[!] Maximo de redirecciones alcanzado ({max_redirecciones})")
        return codigo, cabeceras, cuerpo
    
    def get(self, url: str, seguir_redirects: bool = True) -> Tuple[int, Dict, bytes]:
        """
        Metodo GET simplificado
        
        Args:
            url: URL a solicitar
            seguir_redirects: Si seguir redirecciones automaticamente
        
        Returns:
            Tupla (codigo, cabeceras, cuerpo)
        """
        if seguir_redirects:
            return self.seguir_redirecciones(url)
        else:
            return self.realizar_peticion(url, "GET")
    
    def post(self, url: str, data: Dict) -> Tuple[int, Dict, bytes]:
        """
        TODO 7: Metodo POST con datos
        
        Args:
            url: URL destino
            data: Diccionario con datos a enviar
        
        Returns:
            Tupla (codigo, cabeceras, cuerpo)
        
        Pista: Datos deben ir en el cuerpo de la peticion
        """
        # TODO: Codificar datos como application/x-www-form-urlencoded
        body = urllib.parse._________(data)
        
        # Cabeceras necesarias para POST
        headers = {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Content-Length': str(len(body))
        }
        
        # Parsear URL
        componentes = self.parsear_url(url)
        usar_ssl = componentes['scheme'] == 'https'
        
        # Conectar
        sock = self.conectar_socket(
            componentes['host'],
            componentes['port'],
            usar_ssl
        )
        
        try:
            # Construir peticion
            peticion = self.crear_peticion_http(
                "____",  # TODO: Metodo HTTP
                componentes['host'],
                componentes['path'],
                headers
            )
            
            # TODO: Añadir cuerpo de la peticion
            peticion_completa = peticion + body
            
            print(f"[>] Enviando POST con datos: {data}")
            
            # Enviar
            sock.sendall(peticion_completa.encode('utf-8'))
            
            # Recibir respuesta
            respuesta = b''
            while True:
                chunk = sock.recv(4096)
                if not chunk:
                    break
                respuesta += chunk
            
            return self.parsear_respuesta(respuesta)
            
        finally:
            sock.close()


def prueba_http():
    """Prueba con HTTP simple"""
    print("\n" + "=" * 60)
    print("PRUEBA 1: HTTP (sin SSL)")
    print("=" * 60)
    
    cliente = ClienteHTTP()
    
    # TODO: Probar con un servidor HTTP
    codigo, cabeceras, cuerpo = cliente.get("http://example.com")
    
    print(f"\n[RESULTADO]")
    print(f"Codigo: {codigo}")
    print(f"Tamaño del cuerpo: {len(cuerpo)} bytes")
    print(f"\nPrimeros 500 caracteres del cuerpo:")
    print("-" * 60)
    print(cuerpo[:500].decode('utf-8', errors='ignore'))


def prueba_https():
    """Prueba con HTTPS"""
    print("\n" + "=" * 60)
    print("PRUEBA 2: HTTPS (con TLS/SSL)")
    print("=" * 60)
    
    cliente = ClienteHTTP()
    
    # TODO: Probar con un servidor HTTPS
    codigo, cabeceras, cuerpo = cliente.get("https://www.google.com")
    
    print(f"\n[RESULTADO]")
    print(f"Codigo: {codigo}")
    print(f"Cabeceras importantes:")
    for key in ['content-type', 'content-length', 'server']:
        if key in cabeceras:
            print(f"  - {key}: {cabeceras[key]}")


def prueba_redirecciones():
    """Prueba siguiendo redirecciones"""
    print("\n" + "=" * 60)
    print("PRUEBA 3: Redirecciones HTTP")
    print("=" * 60)
    
    cliente = ClienteHTTP()
    
    # TODO: URL que redirija (muchos sitios redirigen de HTTP a HTTPS)
    codigo, cabeceras, cuerpo = cliente.get("http://github.com", seguir_redirects=True)
    
    print(f"\n[RESULTADO FINAL]")
    print(f"Codigo: {codigo}")


def prueba_post():
    """Prueba metodo POST"""
    print("\n" + "=" * 60)
    print("PRUEBA 4: POST con datos")
    print("=" * 60)
    
    cliente = ClienteHTTP()
    
    # TODO: Probar POST (httpbin.org es util para pruebas)
    datos = {
        'nombre': 'Juan',
        'email': 'juan@example.com',
        'mensaje': 'Hola desde Python'
    }
    
    codigo, cabeceras, cuerpo = cliente.post("https://httpbin.org/post", datos)
    
    print(f"\n[RESULTADO]")
    print(f"Codigo: {codigo}")
    print(f"Respuesta del servidor:")
    print(cuerpo.decode('utf-8', errors='ignore'))


def prueba_certificado():
    """
    TODO 8: Verificar informacion del certificado SSL
    """
    print("\n" + "=" * 60)
    print("PRUEBA 5: Informacion del certificado SSL")
    print("=" * 60)
    
    # Crear contexto SSL
    context = ssl.create_default_context()
    
    # Conectar
    hostname = "www.google.com"
    port = 443
    
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.settimeout(10)
        sock.connect((hostname, port))
        
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(f"[+] Conectado a {hostname}")
            print(f"    - Protocolo SSL: {ssock.version()}")
            print(f"    - Cifrado: {ssock.cipher()}")
            
            # TODO: Obtener certificado
            cert = ssock.________()
            
            print(f"\n[CERTIFICADO]")
            print(f"    - Sujeto: {dict(x[0] for x in cert['subject'])}")
            print(f"    - Emisor: {dict(x[0] for x in cert['issuer'])}")
            print(f"    - Valido desde: {cert['notBefore']}")
            print(f"    - Valido hasta: {cert['notAfter']}")


def main():
    """Funcion principal con menu"""
    print("=" * 60)
    print("CLIENTE HTTP/HTTPS - PYTHON")
    print("=" * 60)
    
    while True:
        print("\n[MENU]")
        print("1. Prueba HTTP simple")
        print("2. Prueba HTTPS")
        print("3. Prueba redirecciones")
        print("4. Prueba POST")
        print("5. Verificar certificado SSL")
        print("6. Peticion personalizada")
        print("7. Salir")
        
        opcion = input("\nSelecciona una opcion: ").strip()
        
        try:
            if opcion == "1":
                prueba_http()
            elif opcion == "2":
                prueba_https()
            elif opcion == "3":
                prueba_redirecciones()
            elif opcion == "4":
                prueba_post()
            elif opcion == "5":
                prueba_certificado()
            elif opcion == "6":
                url = input("URL: ").strip()
                metodo = input("Metodo (GET/POST): ").strip().upper()
                
                cliente = ClienteHTTP()
                
                if metodo == "GET":
                    codigo, cabeceras, cuerpo = cliente.get(url)
                elif metodo == "POST":
                    print("Introduce datos (formato: clave=valor, separados por comas)")
                    datos_str = input("Datos: ").strip()
                    datos = dict(x.split('=') for x in datos_str.split(','))
                    codigo, cabeceras, cuerpo = cliente.post(url, datos)
                
                print(f"\n[RESULTADO]")
                print(f"Codigo: {codigo}")
                print(f"Tamaño: {len(cuerpo)} bytes")
                
            elif opcion == "7":
                print("\n[*] Saliendo...")
                break
            else:
                print("[!] Opcion invalida")
                
        except Exception as e:
            print(f"[!] Error: {e}")
            import traceback
            traceback.print_exc()


if __name__ == "__main__":
    main()