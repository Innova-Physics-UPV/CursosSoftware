public class MotoElectrica extends Vehiculo implements Electrico {
    private double nivelBateria;

    public MotoElectrica(String marca, String modelo, int año) {
        super(marca, modelo, año);
        nivelBateria = 100.0;
    }

    @Override
    public void acelerar() {
        System.out.println("La moto eléctrica acelera rápidamente");
        nivelBateria = nivelBateria - 0.2;
    }

    @Override
    public double calcularConsumo(double distancia) {
        return distancia * 0.15;
    }

    @Override
    public void cargarBateria() {
        nivelBateria = 100.0;
    }

    @Override
    public double getNivelBateria() {
        return nivelBateria;
    }
}
