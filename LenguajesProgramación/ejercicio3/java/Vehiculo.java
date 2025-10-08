abstract class Vehiculo {
    protected String marca;
    protected String modelo;
    protected int año;

    public Vehiculo(String marca, String modelo, int año) {
        this.marca = marca;
        this.modelo = modelo;
        this.año = año;
    }

    public void mostrarInfo() {
        System.out.println("Vehículo: " + marca + " " + modelo + " (" + año + ")");
    }

    public abstract void acelerar();
    public abstract double calcularConsumo(double distancia);
}