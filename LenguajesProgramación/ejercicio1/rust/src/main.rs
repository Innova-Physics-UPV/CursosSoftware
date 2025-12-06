use serde::{Deserialize, Serialize};
use serde_json::to_string_pretty;

#[derive(Serialize, Deserialize, Debug, Clone)]
struct Operacion {
    operando1: f64,
    operando2: f64,
    operador: String,
}

#[derive(Serialize, Deserialize, Debug)]
struct Resultado {
    operacion: Operacion,
    resultado: f64,
}

fn calcular(op: &Operacion) -> f64 {
    match op.operador.as_str() {
        "+" => op.operando1 + op.operando2,
        "-" => op.operando1 - op.operando2,
        "*" => op.operando1 * op.operando2,
        "/" => op.operando1 / op.operando2,
        _ => 0.0,
    }
}

fn main() {
    let operacion = Operacion {
        operando1: 9.0,
        operando2: 3.0,
        operador: "/".to_string(),
    };
    
    let resultado = Resultado {
        operacion: operacion.clone(),
        resultado: calcular(&operacion),
    };
    
    let json = to_string_pretty(&resultado).unwrap();
    println!("{}", json);
}

