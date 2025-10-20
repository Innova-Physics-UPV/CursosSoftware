#!/bin/bash
# Ejercicio 5: Integración de Directorios, Permisos y Git
# Completar las líneas marcadas con ____

echo "=== EJERCICIO 5: INTEGRACIÓN COMPLETA ==="

# Limpiar proyecto anterior si existe
rm -rf webapp 2>/dev/null

echo "=== FASE 1: ESTRUCTURA DEL PROYECTO ==="

# Crear estructura de proyecto web completa
mkdir -p webapp/{src,public,config,tests,docs}
cd webapp

echo "✓ Estructura de directorios creada"

# Inicializar Git
____ ____
echo "✓ Git inicializado"

# Configurar Git
git config user.name "Desarrollador Web"
git config user.email "dev@webapp.com"

echo ""
echo "=== FASE 2: ARCHIVOS DE CONFIGURACIÓN ==="

# Crear .gitignore apropiado
cat > .gitignore << 'EOF'
# Logs
*.log
logs/

# Archivos sensibles
config/secrets.conf
.env
*.key
*.pem

# Dependencias
node_modules/
vendor/
bower_components/

# Archivos temporales
*.tmp
*.swp
*~

# Build
dist/
build/
*.min.js
*.min.css

# Sistema
.DS_Store
Thumbs.db
EOF

echo "✓ .gitignore creado"

# Crear archivos de configuración
mkdir -p config
echo "# Configuración de base de datos" > config/database.conf
echo "DB_HOST=localhost" >> config/database.conf
echo "DB_PORT=5432" >> config/database.conf
echo "DB_NAME=webapp_db" >> config/database.conf

echo "# Secretos - NO COMMITEAR" > config/secrets.conf
echo "API_KEY=sk_test_51234567890" >> config/secrets.conf
echo "JWT_SECRET=supersecret123" >> config/secrets.conf

echo "✓ Archivos de configuración creados"

echo ""
echo "=== FASE 3: CONFIGURACIÓN DE PERMISOS ==="

# Configurar permisos restrictivos para secretos
# Solo el propietario puede leer y escribir
____ ____ config/secrets.conf
echo "✓ Permisos restrictivos en secrets.conf (600)"

# Permisos normales para database.conf
chmod 644 config/database.conf
echo "✓ Permisos estándar en database.conf (644)"

echo ""
echo "=== FASE 4: CÓDIGO FUENTE ==="

# Crear estructura de código fuente
mkdir -p src/{css,js,components}

# Archivo HTML principal
cat > src/index.html << 'EOF'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi WebApp</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <header>
        <h1>Bienvenido a Mi WebApp</h1>
    </header>
    <main>
        <div id="app"></div>
    </main>
    <script src="js/app.js"></script>
</body>
</html>
EOF

# Archivo CSS
cat > src/css/styles.css << 'EOF'
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, sans-serif;
    line-height: 1.6;
    padding: 20px;
}

header {
    background: #333;
    color: #fff;
    padding: 1rem;
    text-align: center;
}
EOF

# Archivo JavaScript
cat > src/js/app.js << 'EOF'
// Aplicación principal
(function() {
    'use strict';
    
    function init() {
        console.log('Aplicación iniciada');
        loadConfig();
    }
    
    function loadConfig() {
        // Cargar configuración
        console.log('Configuración cargada');
    }
    
    document.addEventListener('DOMContentLoaded', init);
})();
EOF

echo "✓ Archivos fuente creados"

# Crear componente de ejemplo
cat > src/components/Header.js << 'EOF'
// Componente Header
class Header {
    constructor(title) {
        this.title = title;
    }
    
    render() {
        return `<header><h1>${this.title}</h1></header>`;
    }
}

export default Header;
EOF

echo "✓ Componentes creados"

echo ""
echo "=== FASE 5: SCRIPTS Y HERRAMIENTAS ==="

# Crear script de despliegue
cat > deploy.sh << 'EOF'
#!/bin/bash
# Script de despliegue automático

echo "=== Iniciando despliegue ==="

# Verificar archivos
if [ ! -f "src/index.html" ]; then
    echo "Error: No se encuentra index.html"
    exit 1
fi

# Crear directorio de build
mkdir -p build

# Copiar archivos
cp -r src/* build/
echo "✓ Archivos copiados a build/"

# Comprimir assets
echo "✓ Assets comprimidos"

echo "=== Despliegue completado ==="
EOF

# Hacer el script ejecutable
____ u+x deploy.sh
echo "✓ Script de despliegue creado y ejecutable"

# Crear script de pruebas
cat > run_tests.sh << 'EOF'
#!/bin/bash
echo "Ejecutando pruebas..."
# Aquí irían los comandos de test
echo "Pruebas completadas"
EOF

chmod u+x run_tests.sh
echo "✓ Script de pruebas creado"

echo ""
echo "=== FASE 6: DOCUMENTACIÓN ==="

# Crear README
cat > README.md << 'EOF'
# WebApp Project

Proyecto web completo con estructura profesional.

## Estructura del Proyecto

```
webapp/
├── src/           # Código fuente
├── config/        # Archivos de configuración
├── tests/         # Pruebas
├── docs/          # Documentación
└── public/        # Archivos públicos
```

## Instalación

1. Clonar el repositorio
2. Configurar variables de entorno
3. Ejecutar `./deploy.sh`

## Tecnologías

- HTML5
- CSS3
- JavaScript (ES6+)
- Git para control de versiones

## Autor

INNOVA PHYSICS - Desarrollo Web
EOF

echo "✓ README.md creado"

echo ""
echo "=== FASE 7: COMMITS INICIALES ==="

# Añadir archivos a Git (respetando .gitignore)
git ____ .

# Hacer commit inicial
git commit -m "____"
echo "✓ Commit inicial realizado"

# Verificar qué archivos están trackeados
echo ""
echo "=== ARCHIVOS EN GIT ==="
git ls-files

echo ""
echo "=== FASE 8: DESARROLLO CON BRANCHES ==="

# Crear rama para nueva característica
____ branch feature/login
git ____ feature/login
echo "✓ Rama feature/login creada y activada"

# Desarrollar característica de login
mkdir -p src/components/auth
cat > src/components/auth/Login.js << 'EOF'
// Componente de Login
class Login {
    constructor() {
        this.isAuthenticated = false;
    }
    
    login(username, password) {
        // Lógica de autenticación
        if (username && password) {
            this.isAuthenticated = true;
            return true;
        }
        return false;
    }
    
    logout() {
        this.isAuthenticated = false;
    }
}

export default Login;
EOF

git add src/components/auth/
git ____ -m "Añadir componente de autenticación"
echo "✓ Feature de login implementada"

# Crear otra feature para perfil de usuario
git checkout -b feature/user-profile
cat > src/components/UserProfile.js << 'EOF'
// Componente de perfil de usuario
class UserProfile {
    constructor(user) {
        this.user = user;
    }
    
    render() {
        return `
            <div class="profile">
                <h2>${this.user.name}</h2>
                <p>${this.user.email}</p>
            </div>
        `;
    }
}

export default UserProfile;
EOF

git add src/components/UserProfile.js
git commit -m "Añadir componente de perfil de usuario"
echo "✓ Feature de perfil implementada"

# Volver a main y fusionar todo
echo ""
echo "=== FASE 9: MERGE DE FEATURES ==="
____ checkout main

# Fusionar feature de login
git ____ feature/login
echo "✓ Feature login fusionada"

# Fusionar feature de perfil
git merge feature/user-profile
echo "✓ Feature perfil fusionada"

echo ""
echo "=== FASE 10: VERSIONADO ==="

# Crear tag de versión
git tag ____ -m "Primera versión funcional con auth y perfil"
echo "✓ Tag v1.0.0 creado"

echo ""
echo "=== FASE 11: VERIFICACIONES DE SEGURIDAD ==="

# Verificar que secrets.conf NO está en Git
if git ls-files | grep -q "secrets.conf"; then
    echo "❌ ERROR: secrets.conf está en Git (problema de seguridad)"
else
    echo "✓ CORRECTO: secrets.conf no está en Git"
fi

# Verificar que .gitignore está en Git
if git ls-files | grep -q ".gitignore"; then
    echo "✓ CORRECTO: .gitignore está en Git"
else
    echo "❌ ERROR: .gitignore no está en Git"
fi

echo ""
echo "=== FASE 12: PERMISOS FINALES ==="

# Listar todos los archivos trackeados por Git
echo "Archivos en el repositorio:"
git ____ 

echo ""
echo "=== VERIFICACIÓN DE PERMISOS ==="
____ -l deploy.sh
ls -l run_tests.sh
ls -l config/secrets.conf
ls -l config/database.conf

echo ""
echo "=== ESTADÍSTICAS DEL PROYECTO ==="
echo "Total de commits: $(git rev-list --count HEAD)"
echo "Total de branches: $(git branch | wc -l)"
echo "Total de archivos en Git: $(git ls-files | wc -l)"
echo "Total de archivos en proyecto: $(find . -type f | wc -l)"
echo "Archivos excluidos por .gitignore: $(($(find . -type f | wc -l) - $(git ls-files | wc -l)))"

echo ""
echo "=== ÁRBOL DEL PROYECTO ==="
tree -L 2 -I 'node_modules|.git' . || ls -R

echo ""
echo "=== RESUMEN DE INTEGRACIÓN ==="
echo "✓ Directorios: Estructura completa creada"
echo "✓ Permisos: Configurados correctamente"
echo "✓ Git: Repositorio inicializado y versionado"
echo "✓ Seguridad: Archivos sensibles protegidos"
echo "✓ Scripts: Herramientas ejecutables"
echo "✓ Documentación: README completo"

echo ""
echo "=== FIN DEL EJERCICIO 5 ==="