use serde::{Deserialize, Serialize};

mod operaciones;

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct Operacion {
    pub operando1: f64,
    pub operando2: f64,
    pub operador: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Resultado {
    operacion: Operacion,
    resultado: f64,
}


fn main() {
    let operacion = Operacion {
        operando1: 10.0,
        operando2: 3.0,
        operador: "+".to_string(),
    };
    
    let resultado = Resultado {
        operacion: operacion.clone(),
        resultado: operaciones::calcular(&operacion) };
    
    let json = serde_json::to_string_pretty(&resultado).unwrap();
    println!("{}", json);
}
