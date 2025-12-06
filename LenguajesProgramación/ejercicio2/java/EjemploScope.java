public class EjemploScope {
    private static String variableClase = "Variable de clase";
    private String variableInstancia = "Variable de instancia";

    public void metodoEjemplo(String parametro) {
        String variableLocal = "Variable local";

        {
            String variableBloque = "Variable de bloque";
            System.out.println(variableBloque);
            // TODO: Imprimir variableLocal y variableInstancia
            System.out.println(variableLocal);
            System.out.println(variableInstancia);
        }

        // TODO: declarar una variable con el mismo nombre que variableInstancia
        // e imprimir ambas
        String variableInstancia = "Variable local con mismo nombre";
        System.out.println("Variable instancia (local): " + variableInstancia);
        System.out.println("Variable instancia (atributo): " + this.variableInstancia);
    }

    public static void main(String[] args) {
        EjemploScope obj = new EjemploScope();
        obj.metodoEjemplo("parámetro");
    }
}
