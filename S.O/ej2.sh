#!/bin/bash
# Ejercicio 2: Gestión Avanzada de Permisos
# Completar las líneas marcadas con ____

echo "=== EJERCICIO 2: GESTIÓN DE PERMISOS ==="

# Crear estructura de archivos
mkdir -p documentos/{publicos,privados,compartidos}

# Crear archivos de prueba
touch documentos/publicos/info.txt
touch documentos/privados/secreto.txt
touch documentos/compartidos/proyecto.txt

echo "Estructura creada"

# Configurar permisos para archivo público
# Todos pueden leer, solo propietario puede escribir (rw-r--r--)
____ ____ documentos/publicos/info.txt

# Configurar permisos para archivo privado
# Solo el propietario puede leer y escribir (rw-------)
chmod ____ documentos/privados/secreto.txt

# Configurar permisos para archivo compartido
# Propietario: lectura y escritura
# Grupo: lectura y escritura
# Otros: solo lectura (rw-rw-r--)
____ 664 ____

# Crear un script ejecutable
cat > ejecutar_backup.sh << 'EOF'
#!/bin/bash
echo "Realizando backup..."
tar -czf backup.tar.gz documentos/
echo "Backup completado"
EOF

# Hacer el script ejecutable solo para el propietario
____ u+x ejecutar_backup.sh

# Cambiar permisos recursivamente de un directorio
# Directorios: 755 (rwxr-xr-x), Archivos: 644 (rw-r--r--)
____ -R 755 documentos/publicos/
find documentos/publicos/ -type f -exec chmod 644 {} \;

# Mostrar todos los permisos configurados
echo ""
echo "=== PERMISOS CONFIGURADOS ==="
____ -l documentos/publicos/info.txt
ls -l documentos/privados/secreto.txt
____ -l documentos/compartidos/proyecto.txt
ls -l ejecutar_backup.sh

echo ""
echo "=== TABLA DE REFERENCIA ==="
echo "Octal | Binario | Simbólico | Significado"
echo "------|---------|-----------|-------------"
echo "  0   |   000   |    ---    | Sin permisos"
echo "  4   |   100   |    r--    | Solo lectura"
echo "  5   |   101   |    r-x    | Lectura y ejecución"
echo "  6   |   110   |    rw-    | Lectura y escritura"
echo "  7   |   111   |    rwx    | Todos los permisos"

echo ""
echo "=== FIN DEL EJERCICIO 2 ==="