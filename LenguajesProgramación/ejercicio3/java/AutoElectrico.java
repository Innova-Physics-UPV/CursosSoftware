public class AutoElectrico extends Automovil implements Electrico {
    private double nivelBateria;

    public AutoElectrico(String marca, String modelo, int año) {
        super(marca, modelo, año, 0.0);
        nivelBateria = 100.0;
    }

    @Override
    public void acelerar() {
        System.out.println("El auto eléctrico acelera silenciosamente");
        nivelBateria = nivelBateria - 0.5;
    }

    @Override
    public double calcularConsumo(double distancia) {
        return distancia * 0.2;
    }

    @Override
    public void cargarBateria() {
        nivelBateria = 100;
        System.out.println("Batería cargada al 100%");
    }

    @Override
    public double getNivelBateria() {
        return nivelBateria;
    }
}