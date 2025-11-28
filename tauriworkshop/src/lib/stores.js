import { writable, derived } from 'svelte/store';

// Datos principales (historial de movimientos)
export const datos = writable([10, 20, 15, 40]);

// Etiquetas para el eje X (pueden ser meses o índices)
export const etiquetas = writable(['Ene', 'Feb', 'Mar', 'Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic']);

// Total derivado de los datos
export const total = derived(datos, ($datos) => $datos.reduce((a, b) => a + b, 0));

// Helper: reset (useful for debugging)
export function resetDemo() {
  datos.set([10, 20, 15, 40]);
  etiquetas.set(['Ene', 'Feb', 'Mar', 'Abr']);
}
