public class Automovil extends Vehiculo {
    private double consumoPorKm;

    public Automovil(String marca, String modelo, int año, double consumoPorKm) {
        super(marca, modelo, año);
        consumoPorKm = consumoPorKm; // Error aquí: asignación a sí mismo
    }

    @Override
    public void acelerar() {
        System.out.println("El automóvil acelera suavemente");
    }

    @Override
    public double calcularConsumo(double distancia) {
        return distancia * consumoPorKm;
    }
}