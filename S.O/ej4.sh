#!/bin/bash
# Ejercicio 4: Control de Versiones con Git
# Completar las líneas marcadas con ____

echo "=== EJERCICIO 4: CONTROL DE VERSIONES CON GIT ==="

# Limpiar proyecto anterior si existe
rm -rf mi_proyecto 2>/dev/null

# Crear directorio del proyecto
mkdir mi_proyecto
cd mi_proyecto

echo "=== FASE 1: INICIALIZACIÓN ==="

# Inicializar repositorio Git
____ init
echo "✓ Repositorio Git inicializado"

# Configurar usuario (ajusta con tus datos)
git config user.name "Estudiante INNOVA"
git config user.email "estudiante@innova.com"
echo "✓ Usuario configurado"

# Crear archivo README
cat > README.md << 'EOF'
# Mi Proyecto

Proyecto de ejemplo para aprender Git y control de versiones.

## Características

- Gestión de versiones con Git
- Trabajo con branches (ramas)
- Control de cambios
- Colaboración en equipo

## Tecnologías

- Bash scripting
- Git version control

## Autor

Estudiante INNOVA PHYSICS
EOF

echo "✓ README.md creado"

# Añadir archivo al staging area
____ ____ README.md

# Realizar primer commit
git ____ -m "Initial commit: añadir README"
echo "✓ Primer commit realizado"

echo ""
echo "=== FASE 2: CONFIGURACIÓN AVANZADA ==="

# Crear archivo .gitignore
cat > .gitignore << 'EOF'
# Archivos de log
*.log
*.tmp

# Dependencias
node_modules/
vendor/

# Archivos de configuración sensibles
.env
config/secrets.conf

# Archivos del sistema
.DS_Store
Thumbs.db
EOF

git add .gitignore
____ commit -m "Añadir .gitignore para archivos excluidos"
echo "✓ .gitignore configurado"

# Ver historial de commits
echo ""
echo "=== HISTORIAL DE COMMITS ==="
git ____

echo ""
echo "=== FASE 3: TRABAJO CON BRANCHES ==="

# Crear nueva rama para desarrollo
____ ____ desarrollo
echo "✓ Rama 'desarrollo' creada"

# Cambiar a la rama desarrollo
git ____ desarrollo
echo "✓ Cambiado a rama 'desarrollo'"

# Crear estructura de proyecto
mkdir -p src tests docs
touch src/app.js src/config.js
touch tests/app.test.js
touch docs/manual.md

# Añadir contenido a los archivos
cat > src/app.js << 'EOF'
// Archivo principal de la aplicación
function main() {
    console.log("Aplicación iniciada");
}

main();
EOF

cat > src/config.js << 'EOF'
// Configuración de la aplicación
const config = {
    appName: "Mi Proyecto",
    version: "1.0.0",
    debug: true
};

module.exports = config;
EOF

git ____ .
git commit -m "Añadir estructura básica del proyecto"
echo "✓ Estructura del proyecto añadida"

# Ver todas las ramas
echo ""
echo "=== RAMAS DISPONIBLES ==="
git ____

echo ""
echo "=== FASE 4: DESARROLLO DE FEATURES ==="

# Crear rama para nueva característica
git checkout -b feature/login
echo "✓ Rama 'feature/login' creada"

# Desarrollar la característica
mkdir -p src/auth
cat > src/auth/login.js << 'EOF'
// Sistema de autenticación
function login(username, password) {
    // Lógica de login
    return true;
}

module.exports = { login };
EOF

git add src/auth/
git commit -m "Añadir sistema de autenticación"
echo "✓ Feature de login implementada"

# Volver a desarrollo y fusionar
echo ""
echo "=== FASE 5: MERGE DE RAMAS ==="
git checkout desarrollo
echo "✓ Vuelto a rama desarrollo"

git ____ feature/login
echo "✓ Feature fusionada en desarrollo"

# Volver a rama principal (main o master)
git checkout ____
echo "✓ Vuelto a rama principal"

# Fusionar desarrollo con main
____ ____ desarrollo
echo "✓ Desarrollo fusionado en main"

echo ""
echo "=== FASE 6: TAGS Y VERSIONES ==="

# Crear tag para versión
git ____ v1.0.0 -m "Primera versión estable"
echo "✓ Tag v1.0.0 creado"

# Mostrar información del repositorio
echo ""
echo "=== INFORMACIÓN DEL REPOSITORIO ==="
echo "--- Remotos ---"
git ____ -v || echo "No hay remotos configurados"

echo ""
echo "--- Tags ---"
git tag

echo ""
echo "--- Gráfico de commits ---"
git ____ --oneline --graph --all

echo ""
echo "=== FASE 7: GESTIÓN DE CAMBIOS ==="

# Simular cambio en archivo
echo ""
echo "// Función adicional" >> src/app.js
echo "✓ Cambio realizado en src/app.js"

# Ver diferencias
echo ""
echo "=== DIFERENCIAS (git diff) ==="
git ____ src/app.js

# Deshacer cambios no commiteados
echo ""
echo "Deshaciendo cambios..."
git ____ src/app.js
echo "✓ Cambios revertidos"

# Verificar estado final
echo ""
echo "=== ESTADO FINAL DEL REPOSITORIO ==="
git ____

echo ""
echo "=== ESTADÍSTICAS FINALES ==="
echo "Total de commits: $(git rev-list --count HEAD)"
echo "Total de ramas: $(git branch | wc -l)"
echo "Total de archivos trackeados: $(git ls-files | wc -l)"

echo ""
echo "=== COMANDOS GIT ÚTILES ==="
echo "git status       - Ver estado actual"
echo "git log          - Ver historial"
echo "git branch       - Listar ramas"
echo "git checkout     - Cambiar de rama"
echo "git merge        - Fusionar ramas"
echo "git diff         - Ver diferencias"
echo "git add          - Añadir al staging"
echo "git commit       - Guardar cambios"
echo "git tag          - Gestionar versiones"

echo ""
echo "=== FIN DEL EJERCICIO 4 ==="