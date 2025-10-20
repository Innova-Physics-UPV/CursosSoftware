// Ejercicio 4: Cliente TCP en Rust
// Objetivo: Conectarse a un servidor TCP y enviar/recibir datos

use std::io::{self, Read, Write};
use std::net::TcpStream;
use std::time::Duration;

/// TODO 1: Implementa la funcion para conectarse al servidor
/// 
/// Args:
///     direccion: String con formato "IP:PUERTO" (ej: "127.0.0.1:8080")
/// 
/// Returns:
///     Result con TcpStream o error de IO
/// 
/// Pista: Usa TcpStream::connect() y set_read_timeout()
fn conectar_servidor(direccion: &str) -> io::Result<TcpStream> {
    println!("[*] Intentando conectar a {}...", direccion);
    
    // TODO: Crear conexion TCP
    let mut stream = TcpStream::__________(_________)?;
    
    // TODO: Establecer timeout de lectura (5 segundos)
    stream.set_read_timeout(Some(Duration::from_secs(___)))?;
    
    println!("[+] Conectado exitosamente!");
    
    Ok(stream)
}

/// TODO 2: Implementa la funcion para enviar datos
/// 
/// Args:
///     stream: Referencia mutable al TcpStream
///     mensaje: String a enviar
/// 
/// Returns:
///     Result con cantidad de bytes enviados o error
/// 
/// Pista: write_all() escribe todos los bytes
fn enviar_mensaje(stream: &mut TcpStream, mensaje: &str) -> io::Result<()> {
    println!("[>] Enviando: {}", mensaje);
    
    // TODO: Convertir string a bytes y enviar
    stream.__________(mensaje.as_bytes())?;
    
    // TODO: Asegurar que los datos se envian inmediatamente
    stream.__________()?;
    
    println!("[+] Mensaje enviado ({} bytes)", mensaje.len());
    
    Ok(())
}

/// TODO 3: Implementa la funcion para recibir datos
/// 
/// Args:
///     stream: Referencia mutable al TcpStream
/// 
/// Returns:
///     Result con String recibido o error
/// 
/// Pista: read_to_string() o un buffer con read()
fn recibir_respuesta(stream: &mut TcpStream) -> io::Result<String> {
    // TODO: Crear buffer para almacenar datos recibidos
    let mut buffer = [0; _____];  // 1024 bytes
    
    println!("[*] Esperando respuesta del servidor...");
    
    // TODO: Leer datos del stream
    let bytes_leidos = stream.______(&mut buffer)?;
    
    if bytes_leidos == 0 {
        return Err(io::Error::new(
            io::ErrorKind::ConnectionAborted,
            "Conexion cerrada por el servidor"
        ));
    }
    
    // TODO: Convertir bytes a String
    let respuesta = String::from_utf8_lossy(&buffer[0..bytes_leidos]).to_string();
    
    println!("[<] Recibido: {} ({} bytes)", respuesta, bytes_leidos);
    
    Ok(respuesta)
}

/// TODO 4: Implementa un chat interactivo con el servidor
/// 
/// Args:
///     stream: Referencia mutable al TcpStream
/// 
/// Pista: Usa un loop y lee desde stdin
fn chat_interactivo(mut stream: TcpStream) -> io::Result<()> {
    println!("\n[*] Modo chat iniciado (escribe 'salir' para terminar)\n");
    
    loop {
        // TODO: Leer entrada del usuario
        print!("Tu mensaje: ");
        io::stdout().flush()?;
        
        let mut input = String::new();
        io::stdin().________(&mut input)?;
        
        let mensaje = input.trim();
        
        // Verificar comando de salida
        if mensaje.eq_ignore_ascii_case("______") {
            println!("[*] Cerrando conexion...");
            break;
        }
        
        if mensaje.is_empty() {
            continue;
        }
        
        // TODO: Enviar mensaje al servidor
        enviar_mensaje(&mut stream, mensaje)?;
        
        // TODO: Recibir respuesta del servidor
        match recibir_respuesta(&mut stream) {
            Ok(respuesta) => {
                println!("Servidor dice: {}\n", respuesta);
            }
            Err(e) => {
                eprintln!("[!] Error al recibir respuesta: {}", e);
                break;
            }
        }
    }
    
    Ok(())
}

/// TODO 5: Funcion para probar conexion simple (enviar un mensaje y recibir respuesta)
fn prueba_simple(direccion: &str, mensaje: &str) -> io::Result<()> {
    // Conectar
    let mut stream = conectar_servidor(direccion)?;
    
    // Enviar mensaje
    enviar_mensaje(&mut stream, mensaje)?;
    
    // Recibir respuesta
    let respuesta = recibir_respuesta(&mut stream)?;
    
    println!("\n[*] Respuesta del servidor: {}", respuesta);
    
    Ok(())
}

fn main() {
    println!("=====================================");
    println!("    CLIENTE TCP - RUST");
    println!("=====================================\n");
    
    // TODO 6: Configuracion del servidor
    // Cambia estos valores segun tu servidor de prueba
    let servidor = "_________:____";  // Ejemplo: "127.0.0.1:8080"
    
    println!("Selecciona el modo:");
    println!("1. Enviar mensaje simple");
    println!("2. Chat interactivo");
    print!("\nOpcion: ");
    io::stdout().flush().unwrap();
    
    let mut opcion = String::new();
    io::stdin().read_line(&mut opcion).unwrap();
    
    let resultado = match opcion.trim() {
        "1" => {
            println!("\n[*] Modo: Mensaje simple");
            print!("Mensaje a enviar: ");
            io::stdout().flush().unwrap();
            
            let mut mensaje = String::new();
            io::stdin().read_line(&mut mensaje).unwrap();
            
            prueba_simple(servidor, mensaje.trim())
        }
        "2" => {
            println!("\n[*] Modo: Chat interactivo");
            let stream = conectar_servidor(servidor)?;
            chat_interactivo(stream)
        }
        _ => {
            println!("[!] Opcion invalida");
            return;
        }
    };
    
    match resultado {
        Ok(_) => println!("\n[+] Programa finalizado correctamente"),
        Err(e) => eprintln!("\n[!] Error: {}", e),
    }
}

// TODO 7: BONUS - Implementa un servidor de prueba simple
// Descomenta y completa el siguiente codigo:

/*
#[cfg(test)]
mod servidor_prueba {
    use std::net::{TcpListener, TcpStream};
    use std::io::{Read, Write};
    use std::thread;

    fn manejar_cliente(mut stream: TcpStream) {
        let mut buffer = [0; 1024];
        
        loop {
            match stream.____(&mut buffer) {
                Ok(0) => break, // Conexion cerrada
                Ok(n) => {
                    let mensaje = String::from_utf8_lossy(&buffer[0..n]);
                    println!("Servidor recibio: {}", mensaje);
                    
                    // Eco: devolver el mismo mensaje
                    let respuesta = format!("Eco: {}", mensaje);
                    stream.write_all(respuesta.as_bytes()).unwrap();
                }
                Err(e) => {
                    eprintln!("Error leyendo del cliente: {}", e);
                    break;
                }
            }
        }
    }

    pub fn iniciar_servidor(puerto: u16) {
        let direccion = format!("127.0.0.1:{}", puerto);
        let listener = TcpListener::____(&direccion).unwrap();
        
        println!("Servidor escuchando en {}", direccion);
        
        for stream in listener.incoming() {
            match stream {
                Ok(stream) => {
                    thread::spawn(|| {
                        manejar_cliente(stream);
                    });
                }
                Err(e) => {
                    eprintln!("Error aceptando conexion: {}", e);
                }
            }
        }
    }
}
*/