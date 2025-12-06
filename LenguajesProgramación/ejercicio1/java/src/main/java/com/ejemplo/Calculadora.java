package com.ejemplo;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class Calculadora {
    
    public static class Operacion {
        private double operando1;
        private double operando2;
        private String operador;
        
        public Operacion(double operando1, double operando2, String operador) {
            this.operando1 = operando1;
            this.operando2 = operando2;
            this.operador = operador;
        }
        
        public double calcular() {
            switch (operador) {
                case "+": return operando1 + operando2;
                case "-": return operando1 - operando2;
                case "*": return operando1 * operando2;
                case "/": return operando1 / operando2;
                default: return 0.0;
            }
        }
    }
    
    public static void main(String[] args) {
        Operacion op = new Operacion(15.0, 4.0, "+");
        
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String json = gson.toJson(op);
        
        System.out.println("Operación: " + json);
        System.out.println("Resultado: " + op.calcular());
    }
}

