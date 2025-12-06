#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char* nombre;
    int edad;
    double salario;
} Empleado;

Empleado* crear_empleado(const char* nombre, int edad, double salario) {
    Empleado* emp = malloc(sizeof(Empleado));
    // TODO: asignar memoria para el nombre
    // emp->nombre = ...
    emp ->nombre = strdup(nombre);
    emp->edad = edad;
    emp->salario = salario;
    return emp;
}

void liberar_empleado(Empleado* emp) {
    // TODO: liberar memoria correctamente
}

void mostrar_empleado(const Empleado* emp) {
    if (emp != NULL) {
        printf("Nombre: %s, Edad: %d, Salario: %.2f\n", 
               emp->nombre, emp->edad, emp->salario);
    }
}

int main() {
    Empleado* emp = crear_empleado("Yuxiao", 30, 50000.0);
    mostrar_empleado(emp);
    // TODO: crear al menos un Empleado y mostrarlo
    return 0;
}
