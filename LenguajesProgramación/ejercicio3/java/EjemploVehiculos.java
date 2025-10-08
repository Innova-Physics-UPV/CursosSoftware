public class EjemploVehiculos {
    public static void probarVehiculo(Vehiculo v) {
        v.mostrarInfo();
        v.acelerar();
        System.out.println("Consumo en 100km: " + v.calcularConsumo(100.0));

        if (v instanceof Electrico) {
            Electrico e = (Electrico) v;
            System.out.println("Nivel de batería: " + e.getNivelBateria() + "%");
        }
        System.out.println();
    }

    public static void main(String[] args) {
        Vehiculo[] vehiculos = {
            new Automovil("Toyota", "Corolla", 2020, 0.07),
            new AutoElectrico("Tesla", "Model 3", 2023)
        };

        for (Vehiculo v : vehiculos) {
            probarVehiculo(v);
        }
    }
}