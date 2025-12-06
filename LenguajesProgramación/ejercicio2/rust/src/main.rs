//Falta cargo.toml, debes agregarlo tu mismo
#[derive(Debug, Clone)]
struct Empleado {
    nombre: String,
    edad: u32,
    salario: f64,
}

impl Empleado {
    fn new(nombre: String, edad: u32, salario: f64) -> Self {
        Empleado { nombre, edad, salario }
    }

    fn procesar(self) -> String {
        format!("Procesando: {}", self.nombre)
    }

    fn mostrar(&self) {
        println!("Empleado: {} - ${}", self.nombre, self.salario);
    }

    fn aumentar_salario(&mut self, porcentaje: f64) {
        self.salario *= 1.0 + porcentaje / 100.0;
    }
}

fn main() {
    let mut emp = Empleado::new("Ana".to_string(), 30, 30000.0);

    // TODO: mostrar, aumentar salario y mostrar de nuevo
    emp.mostrar();
    emp.aumentar_salario(10.0);
    emp.mostrar();

    // TODO: clonar y mover ownership
    let clonado = emp.clone();
    let resultado = clonado.procesar();
    println!("{}", resultado);
    println!("Empleado original después de procesar: {:?}", emp);

    // TODO: iterar sobre un vector de empleados
    let empleados = vec![
        Empleado::new("Carlos".to_string(), 25, 25000.0),
        Empleado::new("Diana".to_string(), 35, 35000.0),
        Empleado::new("Eva".to_string(), 28, 28000.0),
    ];

    for empleado in empleados.iter() {
        empleado.mostrar();
    }
}
