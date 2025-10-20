#!/bin/bash
# Ejercicio 1: Navegación y Estructura de Directorios
# Completar las líneas marcadas con ____

echo "=== EJERCICIO 1: NAVEGACIÓN DE DIRECTORIOS ==="

# Crear directorio principal
____ proyecto_web

# Navegar al directorio creado
____ proyecto_web

# Crear subdirectorios en una sola línea
# La opción -p crea directorios padres automáticamente
mkdir ____ src/{css,js,components}
mkdir public assets

# Mostrar la ruta absoluta actual
echo "Ruta absoluta: $(____ )"

# Crear archivo en subdirectorio
touch src/js/app.js

# Navegar a css desde la ubicación actual
cd ____

# Crear archivos CSS
touch styles.css reset.css

# Volver al directorio proyecto_web (2 niveles arriba)
cd ____

# Listar todo el árbol de directorios creado
# Usar comando tree o alternativa
____ proyecto_web/

# Guardar la estructura en un archivo
____ -R proyecto_web/ > estructura.txt

# Mostrar solo los directorios
find proyecto_web/ -type ____ -print

echo "=== FIN DEL EJERCICIO 1 ==="

# Preguntas para reflexionar:
# 1. ¿Cuál es la diferencia entre una ruta relativa y una absoluta?
# 2. ¿Qué hace el comando mkdir -p?
# 3. ¿Cómo volverías 3 niveles arriba en el árbol de directorios?