pub fn calcular(op: &super::Operacion) -> f64 {
    match op.operador.as_str() {
        "+" => op.operando1 + op.operando2,
        "-" => op.operando1 - op.operando2,
        "*" => op.operando1 * op.operando2,
        "/" => op.operando1 / op.operando2,
        _ => 0.0,
    }
}
