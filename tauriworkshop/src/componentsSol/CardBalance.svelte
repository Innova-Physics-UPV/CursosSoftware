<script>
  import BaseCard from './BaseCard.svelte';
  import { datos } from '../lib/stores.svelte.js';

  // Derivamos el total directamente desde el store de `datos`
  let total = $derived(datos.reduce((a, b) => a + b, 0));
</script>

<BaseCard>
  <div class="contenedor-balance">
    <h3>Balance Total</h3>
    <!-- 2. DATOS: Mostramos la variable -->
    <p class="cifra"> {total} euros</p>
    <!-- Un detalle visual extra -->
    <span class="etiqueta">Disponible</span>
  </div>
</BaseCard>
<style>
  .contenedor-balance {
    display: flex;
    flex-direction: column;
    justify-content: center;
    height: 100%;
  }

  h3 {
    margin: 0;
    color: #6b7280; /* Gris metalizado */
    font-size: 0.9rem;
    text-transform: uppercase; /* Todo mayúsculas queda elegante */
    letter-spacing: 1px;
  }

  .cifra {
    font-size: 3.5rem; /* ¡Muy grande! Es lo más importante */
    font-weight: 800;
    margin: 0.5rem 0;
    
  }

  .etiqueta {
    font-size: 0.8rem;
    background-color: #dcfce7;
    color: #166534;
    padding: 0.25rem 0.75rem;
    border-radius: 999px; /* Bordes totalmente redondos (Píldora) */
    align-self: flex-start; /* Para que la etiqueta no se estire a lo ancho */
    font-weight: 600;
  }
</style>