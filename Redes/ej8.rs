// Ejercicio 8: Servidor TCP Multi-cliente (Chat)
// Objetivo: Crear servidor TCP que maneje multiples clientes simultaneamente

use std::io::{self, Read, Write, BufRead, BufReader};
use std::net::{TcpListener, TcpStream};
use std::sync::{Arc, Mutex};
use std::thread;
use std::collections::HashMap;

// TODO 1: Estructura para representar un cliente conectado
#[derive(Clone)]
struct Cliente {
    id: usize,
    nombre: String,
    // TODO: Añadir campos necesarios
}

// TODO 2: Estado compartido del servidor
struct EstadoServidor {
    clientes: HashMap<usize, TcpStream>,
    nombres: HashMap<usize, String>,
    proximo_id: usize,
}

impl EstadoServidor {
    fn new() -> Self {
        EstadoServidor {
            clientes: HashMap::new(),
            nombres: HashMap::new(),
            proximo_id: 1,
        }
    }
    
    /// TODO 3: Registrar nuevo cliente
    fn registrar_cliente(&mut self, stream: TcpStream, nombre: String) -> usize {
        let id = self.proximo_id;
        self.proximo_id += 1;
        
        // TODO: Clonar stream para poder guardarlo
        // Pista: try_clone()
        match stream.________() {
            Ok(stream_clonado) => {
                self.clientes.insert(id, stream_clonado);
                self.nombres.insert(id, nombre);
                println!("[+] Cliente {} registrado con ID {}", 
                         self.nombres.get(&id).unwrap(), id);
            }
            Err(e) => {
                eprintln!("[!] Error clonando stream: {}", e);
            }
        }
        
        id
    }
    
    /// TODO 4: Eliminar cliente desconectado
    fn eliminar_cliente(&mut self, id: usize) {
        if let Some(nombre) = self.nombres.remove(&id) {
            self.clientes.remove(&id);
            println!("[-] Cliente {} (ID {}) desconectado", nombre, id);
        }
    }
    
    /// TODO 5: Broadcast de mensaje a todos los clientes
    fn broadcast(&mut self, mensaje: &str, remitente_id: usize) {
        let nombre_remitente = self.nombres.get(&remitente_id)
            .cloned()
            .unwrap_or_else(|| "Desconocido".to_string());
        
        let mensaje_formateado = format!("[{}]: {}\n", nombre_remitente, mensaje);
        let mut clientes_a_eliminar = Vec::new();
        
        // TODO: Enviar mensaje a todos los clientes excepto el remitente
        for (id, stream) in self.clientes.iter_mut() {
            if *id != remitente_id {
                // TODO: Escribir mensaje al stream
                if let Err(e) = stream.__________(mensaje_formateado.as_bytes()) {
                    eprintln!("[!] Error enviando a cliente {}: {}", id, e);
                    clientes_a_eliminar.push(*id);
                }
            }
        }
        
        // Limpiar clientes con error
        for id in clientes_a_eliminar {
            self.eliminar_cliente(id);
        }
    }
    
    /// TODO 6: Enviar mensaje privado a un cliente especifico
    fn mensaje_privado(&mut self, destinatario_id: usize, mensaje: &str, 
                       remitente_id: usize) -> io::Result<()> {
        let nombre_remitente = self.nombres.get(&remitente_id)
            .cloned()
            .unwrap_or_else(|| "Desconocido".to_string());
        
        let mensaje_formateado = format!("[PRIVADO de {}]: {}\n", 
                                        nombre_remitente, mensaje);
        
        // TODO: Obtener stream del destinatario y enviar mensaje
        if let Some(stream) = self.clientes.get_mut(&destinatario_id) {
            stream.write_all(mensaje_formateado.as_bytes())?;
            stream.________?()?; // Asegurar envio inmediato
            Ok(())
        } else {
            Err(io::Error::new(io::ErrorKind::NotFound, "Cliente no encontrado"))
        }
    }
    
    /// TODO 7: Listar todos los clientes conectados
    fn listar_clientes(&self) -> String {
        let mut lista = String::from("=== CLIENTES CONECTADOS ===\n");
        
        for (id, nombre) in &self.nombres {
            lista.push_str(&format!("  - {} (ID: {})\n", nombre, id));
        }
        
        lista.push_str("===========================\n");
        lista
    }
}

/// TODO 8: Manejar un cliente individual
fn manejar_cliente(
    mut stream: TcpStream,
    estado: Arc<Mutex<EstadoServidor>>,
) -> io::Result<()> {
    // Obtener direccion del cliente
    let direccion = stream.peer_addr()?;
    println!("[*] Nueva conexion desde: {}", direccion);
    
    // TODO: Solicitar nombre al cliente
    stream.write_all(b"Bienvenido al servidor de chat!\n")?;
    stream.write_all(b"Introduce tu nombre: ")?;
    stream.flush()?;
    
    // Leer nombre
    let mut reader = BufReader::new(stream.try_clone()?);
    let mut nombre = String::new();
    reader.________(&mut nombre)?;
    let nombre = nombre.trim().to_string();
    
    if nombre.is_empty() {
        stream.write_all(b"Nombre invalido. Desconectando...\n")?;
        return Ok(());
    }
    
    // TODO: Registrar cliente en el estado compartido
    let cliente_id = {
        let mut estado = estado.________().unwrap();
        estado.registrar_cliente(stream.try_clone()?, nombre.clone())
    };
    
    // Mensaje de bienvenida
    let bienvenida = format!("Hola, {}! Tu ID es {}. Usa /help para ver comandos.\n", 
                            nombre, cliente_id);
    stream.write_all(bienvenida.as_bytes())?;
    
    // Notificar a todos
    {
        let mut estado = estado.lock().unwrap();
        let anuncio = format!("{} se ha unido al chat", nombre);
        estado.broadcast(&anuncio, cliente_id);
    }
    
    // TODO 9: Loop principal - leer mensajes del cliente
    loop {
        let mut mensaje = String::new();
        
        match reader.read_line(&mut mensaje) {
            Ok(0) => {
                // Cliente desconectado
                break;
            }
            Ok(_) => {
                let mensaje = mensaje.trim();
                
                if mensaje.is_empty() {
                    continue;
                }
                
                // TODO: Procesar comandos
                if mensaje.starts_with('/') {
                    procesar_comando(&mut stream, mensaje, cliente_id, &estado)?;
                } else {
                    // Mensaje normal - broadcast
                    let mut estado = estado.lock().unwrap();
                    estado.__________(mensaje, cliente_id);
                }
            }
            Err(e) => {
                eprintln!("[!] Error leyendo del cliente {}: {}", cliente_id, e);
                break;
            }
        }
    }
    
    // Limpiar cliente desconectado
    {
        let mut estado = estado.lock().unwrap();
        let anuncio = format!("{} ha salido del chat", nombre);
        estado.broadcast(&anuncio, cliente_id);
        estado.eliminar_cliente(cliente_id);
    }
    
    Ok(())
}

/// TODO 10: Procesar comandos especiales
fn procesar_comando(
    stream: &mut TcpStream,
    comando: &str,
    cliente_id: usize,
    estado: &Arc<Mutex<EstadoServidor>>,
) -> io::Result<()> {
    let partes: Vec<&str> = comando.split_whitespace().collect();
    
    if partes.is_empty() {
        return Ok(());
    }
    
    match partes[0] {
        "/help" => {
            let ayuda = r#"
=== COMANDOS DISPONIBLES ===
/help          - Mostrar esta ayuda
/list          - Listar clientes conectados
/msg ID texto  - Mensaje privado al cliente ID
/salir         - Desconectar del servidor
===========================
"#;
            stream.__________(ayuda.as_bytes())?;
        }
        
        "/list" => {
            let estado = estado.lock().unwrap();
            let lista = estado.listar_clientes();
            stream.write_all(lista.as_bytes())?;
        }
        
        "/msg" => {
            // TODO: Implementar mensaje privado
            // Formato: /msg ID mensaje
            if partes.len() < 3 {
                stream.write_all(b"Uso: /msg ID mensaje\n")?;
            } else {
                // TODO: Parsear ID del destinatario
                if let Ok(dest_id) = partes[1].parse::<usize>() {
                    let mensaje = partes[2..].join(" ");
                    
                    let mut estado = estado.lock().unwrap();
                    match estado.mensaje_privado(dest_id, &mensaje, cliente_id) {
                        Ok(_) => {
                            stream.write_all(b"Mensaje enviado\n")?;
                        }
                        Err(e) => {
                            let error = format!("Error: {}\n", e);
                            stream.write_all(error.as_bytes())?;
                        }
                    }
                } else {
                    stream.write_all(b"ID invalido\n")?;
                }
            }
        }
        
        "/salir" => {
            stream.write_all(b"Adios!\n")?;
            // El cliente se desconectara
        }
        
        _ => {
            stream.write_all(b"Comando desconocido. Usa /help\n")?;
        }
    }
    
    stream.flush()?;
    Ok(())
}

/// TODO 11: Funcion principal del servidor
fn main() -> io::Result<()> {
    println!("===================================");
    println!("   SERVIDOR TCP MULTI-CLIENTE");
    println!("===================================\n");
    
    // TODO: Configurar direccion y puerto
    let direccion = "___________:____"; // Ejemplo: "127.0.0.1:8080"
    
    // TODO: Crear listener TCP
    println!("[*] Intentando iniciar servidor en {}...", direccion);
    let listener = TcpListener::______(direccion)?;
    println!("[+] Servidor escuchando en {}", direccion);
    println!("[*] Esperando conexiones...\n");
    
    // TODO: Crear estado compartido
    let estado = Arc::new(Mutex::new(EstadoServidor::new()));
    
    // TODO 12: Loop principal - aceptar conexiones
    for stream in listener.incoming() {
        match stream {
            Ok(stream) => {
                // TODO: Clonar Arc para pasar al thread
                let estado_clone = Arc::______(&estado);
                
                // TODO: Crear thread para manejar cliente
                thread::________(move || {
                    if let Err(e) = manejar_cliente(stream, estado_clone) {
                        eprintln!("[!] Error manejando cliente: {}", e);
                    }
                });
            }
            Err(e) => {
                eprintln!("[!] Error aceptando conexion: {}", e);
            }
        }
    }
    
    Ok(())
}

// TODO 13: BONUS - Implementar cliente de prueba
#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_cliente_simple() {
        // TODO: Implementar cliente de prueba que se conecte al servidor
        // Pista: TcpStream::connect()
    }
}