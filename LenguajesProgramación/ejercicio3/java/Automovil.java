public class Automovil extends Vehiculo {
    private double consumoPorKm;

    public Automovil(String marca, String modelo, int año, double consumoPorKm) {
        super(marca, modelo, año);
        this.consumoPorKm = consumoPorKm;
    }

    @Override
    public void acelerar() {
        System.out.println("El automóvil acelera suavemente");
    }

    @Override
    public double calcularConsumo(double distancia) {
        return distancia * consumoPorKm; //Aquí se calcula el consumo de litros del vehiculo
    }
}