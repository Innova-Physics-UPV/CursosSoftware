// Ejercicio 10: Resolucion DNS en Rust
// Objetivo: Implementar cliente DNS que resuelva nombres de dominio

use std::net::{UdpSocket, Ipv4Addr};
use std::io::{self, Write};
use std::time::Duration;
use std::collections::HashMap;

// TODO 1: Constantes DNS
const DNS_PORT: u16 = 53;
const DNS_HEADER_SIZE: usize = 12;

// Tipos de registros DNS
#[derive(Debug, Clone, Copy)]
enum TipoRegistro {
    A = 1,      // IPv4
    NS = 2,     // Name Server
    CNAME = 5,  // Canonical Name
    MX = 15,    // Mail Exchange
    AAAA = 28,  // IPv6
}

impl TipoRegistro {
    fn from_u16(valor: u16) -> Option<Self> {
        match valor {
            1 => Some(TipoRegistro::A),
            2 => Some(TipoRegistro::NS),
            5 => Some(TipoRegistro::CNAME),
            15 => Some(TipoRegistro::MX),
            28 => Some(TipoRegistro::AAAA),
            _ => None,
        }
    }
}

// TODO 2: Estructura para la cabecera DNS
#[derive(Debug)]
struct CabeceraDNS {
    id: u16,              // Identificador de transaccion
    flags: u16,           // Flags de control
    num_preguntas: u16,   // Numero de preguntas
    num_respuestas: u16,  // Numero de respuestas
    num_autoridad: u16,   // Numero de registros de autoridad
    num_adicional: u16,   // Numero de registros adicionales
}

impl CabeceraDNS {
    /// TODO 3: Crear cabecera DNS para una consulta
    fn nueva_consulta(id: u16, num_preguntas: u16) -> Self {
        // Flags para consulta estandar:
        // QR=0 (consulta), Opcode=0 (query), RD=1 (recursion desired)
        // Flags: 0000 0001 0000 0000 = 0x0100
        
        CabeceraDNS {
            id,
            flags: 0x____,  // TODO: Completar flags
            num_preguntas,
            num_respuestas: 0,
            num_autoridad: 0,
            num_adicional: 0,
        }
    }
    
    /// TODO 4: Serializar cabecera a bytes
    fn a_bytes(&self) -> Vec<u8> {
        let mut bytes = Vec::new();
        
        // TODO: Convertir cada campo a bytes (big-endian / network byte order)
        bytes.extend_from_slice(&self.id.________());
        bytes.extend_from_slice(&self.flags.to_be_bytes());
        bytes.extend_from_slice(&self.num_preguntas.to_be_bytes());
        bytes.extend_from_slice(&self.num_respuestas.to_be_bytes());
        bytes.extend_from_slice(&self.num_autoridad.to_be_bytes());
        bytes.extend_from_slice(&self.num_adicional.to_be_bytes());
        
        bytes
    }
    
    /// TODO 5: Parsear cabecera desde bytes
    fn desde_bytes(bytes: &[u8]) -> io::Result<Self> {
        if bytes.len() < DNS_HEADER_SIZE {
            return Err(io::Error::new(
                io::ErrorKind::InvalidData,
                "Cabecera DNS incompleta"
            ));
        }
        
        // TODO: Parsear cada campo (big-endian)
        Ok(CabeceraDNS {
            id: u16::from_be_bytes([bytes[0], bytes[1]]),
            flags: u16::_____________([bytes[2], bytes[3]]),
            num_preguntas: u16::from_be_bytes([bytes[4], bytes[5]]),
            num_respuestas: u16::from_be_bytes([bytes[6], bytes[7]]),
            num_autoridad: u16::from_be_bytes([bytes[8], bytes[9]]),
            num_adicional: u16::from_be_bytes([bytes[10], bytes[11]]),
        })
    }
}

/// TODO 6: Codificar nombre de dominio en formato DNS
/// Ejemplo: "www.google.com" -> 3www6google3com0
fn codificar_nombre_dns(nombre: &str) -> Vec<u8> {
    let mut bytes = Vec::new();
    
    // Dividir por puntos
    for parte in nombre.split('.') {
        // TODO: Añadir longitud de la parte
        bytes.push(parte.len() as u8);
        
        // TODO: Añadir bytes de la parte
        bytes.extend_from_slice(parte.as_bytes());
    }
    
    // TODO: Terminar con byte 0
    bytes.push(__);
    
    bytes
}

/// TODO 7: Decodificar nombre de dominio desde formato DNS
fn decodificar_nombre_dns(bytes: &[u8], offset: usize) -> io::Result<(String, usize)> {
    let mut nombre = String::new();
    let mut pos = offset;
    let mut saltos = 0;
    let mut primera_pos = None;
    
    loop {
        // Proteccion contra loops infinitos
        if saltos > 5 {
            return Err(io::Error::new(
                io::ErrorKind::InvalidData,
                "Demasiados saltos en compresion DNS"
            ));
        }
        
        if pos >= bytes.len() {
            return Err(io::Error::new(
                io::ErrorKind::InvalidData,
                "Offset fuera de rango"
            ));
        }
        
        let longitud = bytes[pos];
        
        // TODO: Verificar si es un puntero (compresion)
        // Los dos bits mas altos = 11 indican puntero
        if longitud & 0xC0 == 0xC0 {
            if pos + 1 >= bytes.len() {
                return Err(io::Error::new(
                    io::ErrorKind::InvalidData,
                    "Puntero DNS incompleto"
                ));
            }
            
            // Extraer offset del puntero
            let puntero_offset = (((longitud & 0x3F) as usize) << 8) | (bytes[pos + 1] as usize);
            
            if primera_pos.is_none() {
                primera_pos = Some(pos + 2);
            }
            
            pos = puntero_offset;
            saltos += 1;
            continue;
        }
        
        // TODO: Si longitud es 0, fin del nombre
        if longitud == 0 {
            pos += 1;
            break;
        }
        
        // Leer etiqueta
        pos += 1;
        if pos + longitud as usize > bytes.len() {
            return Err(io::Error::new(
                io::ErrorKind::InvalidData,
                "Etiqueta DNS incompleta"
            ));
        }
        
        // Añadir punto si no es la primera etiqueta
        if !nombre.is_empty() {
            nombre.push('.');
        }
        
        // Añadir etiqueta
        let etiqueta = String::from_utf8_lossy(&bytes[pos..pos + longitud as usize]);
        nombre.push_str(&etiqueta);
        
        pos += longitud as usize;
    }
    
    // Retornar nombre y posicion final
    let pos_final = primera_pos.unwrap_or(pos);
    Ok((nombre, pos_final))
}

/// TODO 8: Construir consulta DNS completa
fn construir_consulta_dns(dominio: &str, tipo: TipoRegistro, id: u16) -> Vec<u8> {
    let mut consulta = Vec::new();
    
    // TODO: Añadir cabecera
    let cabecera = CabeceraDNS::nueva_consulta(id, 1);
    consulta.extend_from_slice(&cabecera.________());
    
    // TODO: Añadir pregunta (QNAME)
    consulta.extend_from_slice(&codificar_nombre_dns(dominio));
    
    // TODO: Añadir QTYPE (tipo de registro)
    consulta.extend_from_slice(&(tipo as u16).to_be_bytes());
    
    // TODO: Añadir QCLASS (1 = IN = Internet)
    consulta.extend_from_slice(&1u16.________());
    
    consulta
}

/// TODO 9: Parsear respuesta DNS
fn parsear_respuesta_dns(respuesta: &[u8]) -> io::Result<Vec<String>> {
    // Parsear cabecera
    let cabecera = CabeceraDNS::desde_bytes(respuesta)?;
    
    println!("\n[+] Cabecera DNS:");
    println!("    ID: {}", cabecera.id);
    println!("    Preguntas: {}", cabecera.num_preguntas);
    println!("    Respuestas: {}", cabecera.num_respuestas);
    
    let mut pos = DNS_HEADER_SIZE;
    
    // TODO: Saltar las preguntas
    for _ in 0..cabecera.num_preguntas {
        // Saltar QNAME
        let (_, nueva_pos) = decodificar_nombre_dns(respuesta, pos)?;
        pos = nueva_pos;
        
        // Saltar QTYPE y QCLASS (4 bytes)
        pos += 4;
    }
    
    // TODO: Parsear respuestas
    let mut resultados = Vec::new();
    
    for i in 0..cabecera.num_respuestas {
        println!("\n[+] Respuesta #{}:", i + 1);
        
        // Leer NAME
        let (nombre, nueva_pos) = decodificar_nombre_dns(respuesta, pos)?;
        pos = nueva_pos;
        
        if pos + 10 > respuesta.len() {
            break;
        }
        
        // Leer TYPE, CLASS, TTL, RDLENGTH
        let tipo = u16::from_be_bytes([respuesta[pos], respuesta[pos + 1]]);
        let _clase = u16::from_be_bytes([respuesta[pos + 2], respuesta[pos + 3]]);
        let ttl = u32::from_be_bytes([
            respuesta[pos + 4],
            respuesta[pos + 5],
            respuesta[pos + 6],
            respuesta[pos + 7],
        ]);
        let rdlength = u16::from_be_bytes([respuesta[pos + 8], respuesta[pos + 9]]) as usize;
        
        pos += 10;
        
        println!("    Nombre: {}", nombre);
        println!("    Tipo: {:?}", TipoRegistro::from_u16(tipo));
        println!("    TTL: {} segundos", ttl);
        
        // TODO: Parsear RDATA segun el tipo
        if pos + rdlength > respuesta.len() {
            break;
        }
        
        let rdata = &respuesta[pos..pos + rdlength];
        
        match TipoRegistro::from_u16(tipo) {
            Some(TipoRegistro::A) => {
                // IPv4 (4 bytes)
                if rdlength == 4 {
                    let ip = Ipv4Addr::new(rdata[0], rdata[1], rdata[2], rdata[3]);
                    println!("    IP: {}", ip);
                    resultados.push(ip.to_string());
                }
            }
            Some(TipoRegistro::CNAME) => {
                // Nombre canonico
                let (cname, _) = decodificar_nombre_dns(respuesta, pos)?;
                println!("    CNAME: {}", cname);
                resultados.push(cname);
            }
            Some(TipoRegistro::MX) => {
                // Mail exchange
                if rdlength >= 2 {
                    let preferencia = u16::from_be_bytes([rdata[0], rdata[1]]);
                    let (exchange, _) = decodificar_nombre_dns(respuesta, pos + 2)?;
                    println!("    Preferencia: {}", preferencia);
                    println!("    Exchange: {}", exchange);
                    resultados.push(format!("{} ({})", exchange, preferencia));
                }
            }
            _ => {
                println!("    RDATA: {} bytes", rdlength);
            }
        }
        
        pos += rdlength;
    }
    
    Ok(resultados)
}

/// TODO 10: Resolver dominio usando DNS
fn resolver_dns(dominio: &str, servidor_dns: &str, tipo: TipoRegistro) -> io::Result<Vec<String>> {
    println!("\n[*] Resolviendo: {}", dominio);
    println!("[*] Servidor DNS: {}", servidor_dns);
    println!("[*] Tipo: {:?}", tipo);
    
    // TODO: Crear socket UDP
    let socket = UdpSocket::____("0.0.0.0:0")?;
    socket.set_read_timeout(Some(Duration::from_secs(5)))?;
    
    // TODO: Construir consulta DNS
    let id = 1234u16; // ID arbitrario
    let consulta = construir_consulta_dns(dominio, tipo, id);
    
    println!("\n[>] Enviando consulta DNS ({} bytes)...", consulta.len());
    
    // TODO: Enviar consulta al servidor DNS
    let direccion_dns = format!("{}:{}", servidor_dns, DNS_PORT);
    socket.________(&consulta, &direccion_dns)?;
    
    // TODO: Recibir respuesta
    let mut buffer = [0u8; 512]; // Tamaño maximo de paquete DNS sin EDNS
    let (bytes_recibidos, _) = socket.______(&mut buffer)?;
    
    println!("[<] Respuesta recibida ({} bytes)", bytes_recibidos);
    
    // Parsear respuesta
    parsear_respuesta_dns(&buffer[..bytes_recibidos])
}

/// TODO 11: Cache DNS simple
struct CacheDNS {
    cache: HashMap<String, Vec<String>>,
}

impl CacheDNS {
    fn new() -> Self {
        CacheDNS {
            cache: HashMap::new(),
        }
    }
    
    fn obtener(&self, dominio: &str) -> Option<&Vec<String>> {
        self.cache._____(dominio)
    }
    
    fn guardar(&mut self, dominio: String, resultados: Vec<String>) {
        self.cache._______(dominio, resultados);
    }
    
    fn mostrar(&self) {
        println!("\n=== CACHE DNS ===");
        if self.cache.is_empty() {
            println!("Cache vacio");
        } else {
            for (dominio, ips) in &self.cache {
                println!("{}: {:?}", dominio, ips);
            }
        }
        println!("=================\n");
    }
}

fn main() -> io::Result<()> {
    println!("========================================");
    println!("   CLIENTE DNS - RUST");
    println!("========================================\n");
    
    let mut cache = CacheDNS::new();
    
    // Servidores DNS publicos
    let servidores_dns = vec![
        ("Google", "8.8.8.8"),
        ("Cloudflare", "1.1.1.1"),
        ("Quad9", "9.9.9.9"),
    ];
    
    loop {
        println!("\n[MENU]");
        println!("1. Resolver dominio (A record - IPv4)");
        println!("2. Resolver dominio (MX record - Mail)");
        println!("3. Mostrar cache");
        println!("4. Limpiar cache");
        println!("5. Salir");
        
        print!("\nOpcion: ");
        io::stdout().flush()?;
        
        let mut opcion = String::new();
        io::stdin().read_line(&mut opcion)?;
        
        match opcion.trim() {
            "1" | "2" => {
                print!("Dominio a resolver: ");
                io::stdout().flush()?;
                
                let mut dominio = String::new();
                io::stdin().read_line(&mut dominio)?;
                let dominio = dominio.trim();
                
                if dominio.is_empty() {
                    println!("[!] Dominio invalido");
                    continue;
                }
                
                // Verificar cache
                if let Some(resultados) = cache.obtener(dominio) {
                    println!("\n[CACHE] Resultados en cache:");
                    for ip in resultados {
                        println!("  - {}", ip);
                    }
                    continue;
                }
                
                // Seleccionar servidor DNS
                println!("\nServidores DNS disponibles:");
                for (i, (nombre, _)) in servidores_dns.iter().enumerate() {
                    println!("{}. {}", i + 1, nombre);
                }
                
                print!("Selecciona servidor (1-{}): ", servidores_dns.len());
                io::stdout().flush()?;
                
                let mut sel = String::new();
                io::stdin().read_line(&mut sel)?;
                
                let idx = sel.trim().parse::<usize>().unwrap_or(1) - 1;
                let servidor = if idx < servidores_dns.len() {
                    servidores_dns[idx].1
                } else {
                    servidores_dns[0].1
                };
                
                // Determinar tipo
                let tipo = if opcion.trim() == "1" {
                    TipoRegistro::A
                } else {
                    TipoRegistro::MX
                };
                
                // Resolver
                match resolver_dns(dominio, servidor, tipo) {
                    Ok(resultados) => {
                        println!("\n[RESULTADO]");
                        if resultados.is_empty() {
                            println!("No se encontraron registros");
                        } else {
                            for resultado in &resultados {
                                println!("  - {}", resultado);
                            }
                            
                            // Guardar en cache
                            cache.guardar(dominio.to_string(), resultados);
                        }
                    }
                    Err(e) => {
                        eprintln!("\n[!] Error: {}", e);
                    }
                }
            }
            
            "3" => {
                cache.mostrar();
            }
            
            "4" => {
                cache = CacheDNS::new();
                println!("\n[+] Cache limpiado");
            }
            
            "5" => {
                println!("\n[*] Saliendo...");
                break;
            }
            
            _ => {
                println!("[!] Opcion invalida");
            }
        }
    }
    
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_codificar_nombre() {
        let nombre = "www.google.com";
        let codificado = codificar_nombre_dns(nombre);
        
        // TODO: Verificar formato correcto
        // Deberia ser: 3www6google3com0
        assert_eq!(codificado[0], 3);  // Longitud de "www"
        assert_eq!(codificado[4], 6);  // Longitud de "google"
        assert_eq!(codificado[11], 3); // Longitud de "com"
        assert_eq!(*codificado.last().unwrap(), 0); // Termina en 0
    }
    
    #[test]
    fn test_cabecera_dns() {
        let cabecera = CabeceraDNS::nueva_consulta(1234, 1);
        let bytes = cabecera.a_bytes();
        
        assert_eq!(bytes.len(), DNS_HEADER_SIZE);
        
        // TODO: Parsear de vuelta
        let parseada = CabeceraDNS::desde_bytes(&bytes).unwrap();
        assert_eq!(parseada.id, 1234);
        assert_eq!(parseada.num_preguntas, 1);
    }
}