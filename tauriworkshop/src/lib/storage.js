import { writeTextFile, BaseDirectory } from '@tauri-apps/api/fs';

export async function exportarDatos(datos) {
    try {
        const contenido = JSON.stringify(datos, null, 2);
        
        // Escribe en: Users/TuUsuario/Documents/reporte.json
        await writeTextFile('reporte.json', contenido, { 
            dir: BaseDirectory.Document 
        });
        
        return true;
    } catch (error) {
        console.error("Error Tauri:", error);
        return false;
    }
}