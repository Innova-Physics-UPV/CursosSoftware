#!/bin/bash
# Ejercicio 3: Operaciones CRUD y Manipulación de Archivos
# Completar las líneas marcadas con ____

echo "=== EJERCICIO 3: OPERACIONES CRUD ==="

# CREATE: Crear base de datos de empleados
echo "=== FASE 1: CREATE (Crear) ==="

____ empleados.csv << EOF
ID,Nombre,Cargo,Departamento,Salario
1,Ana García,Desarrolladora,IT,45000
2,Carlos López,Analista,IT,42000
3,María Rodríguez,Diseñadora,Marketing,40000
4,Juan Martínez,DevOps,IT,48000
EOF

echo "✓ Archivo empleados.csv creado"

# CREATE: Archivo de log con timestamp
echo "[$(date)] Sistema iniciado" ____ sistema.log
echo "✓ Log del sistema creado"

# READ: Leer y mostrar contenido
echo ""
echo "=== FASE 2: READ (Leer) ==="
echo "Contenido completo del archivo:"
____ empleados.csv

# READ: Buscar líneas específicas
echo ""
echo "Empleados del departamento IT:"
____ "IT" empleados.csv

# READ: Contar líneas (restar 1 por el header)
echo ""
total_lineas=$(____ -l empleados.csv | cut -d' ' -f1)
total_empleados=$((total_lineas - 1))
echo "Total de empleados: $total_empleados"

# UPDATE: Añadir nuevo empleado
echo ""
echo "=== FASE 3: UPDATE (Actualizar) ==="
echo "5,Pedro Sánchez,Tester,QA,38000" ____ empleados.csv
echo "✓ Nuevo empleado añadido"

# UPDATE: Modificar contenido (simular aumento de salario del 10%)
echo "✓ Procesando aumento de salario..."
# Usar sed para reemplazar salario de Ana García (45000 -> 49500)
____ 's/45000/49500/' empleados.csv > empleados_temp.csv
mv empleados_temp.csv empleados.csv
echo "✓ Salario actualizado"

# UPDATE: Añadir timestamp al log
echo "[$(____)] Datos actualizados - Nuevo empleado añadido" >> sistema.log

# Mostrar contenido actualizado
echo ""
echo "Archivo actualizado:"
cat empleados.csv

# Crear backup antes de posibles eliminaciones
echo ""
echo "=== FASE 4: BACKUP ==="
____ empleados.csv empleados_backup_$(date +%Y%m%d).csv
____ sistema.log sistema_backup.log
echo "✓ Backups creados"

# DELETE: Eliminar archivos temporales
echo ""
echo "=== FASE 5: DELETE (Eliminar) ==="
# Crear archivo temporal de prueba
touch archivo_temporal.tmp
echo "Archivo temporal creado para demostración"

# Eliminar archivos .tmp
____ -f *.tmp 2>/dev/null
echo "✓ Archivos temporales eliminados"

# Verificar existencia de archivo principal
if [ ____ empleados.csv ]; then
    echo ""
    echo "✓ Verificación: archivo empleados.csv existe"
    ____ -lh empleados.csv
fi

# Mostrar logs del sistema
echo ""
echo "=== LOG DEL SISTEMA ==="
cat sistema.log

echo ""
echo "=== RESUMEN DE OPERACIONES ==="
echo "CREATE: ✓ Archivos creados"
echo "READ:   ✓ Datos leídos y filtrados"
echo "UPDATE: ✓ Información actualizada"
echo "DELETE: ✓ Archivos temporales eliminados"

echo ""
echo "=== FIN DEL EJERCICIO 3 ==="