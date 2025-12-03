<script lang="ts">
    import BaseCard from './BaseCard.svelte';
	import {datos} from '../lib/stores.svelte.js';
    // TODO 1: Crea las variables reactivas 'nuevoGasto' y 'mensajeError'
    // Pista: let variable = $state(...);
	let nuevoGasto = $state(null);
	let mensajeError = $state('')

    function guardar() {
		if (nuevoGasto == null){
		mensajeError = 'Error';
		}
		else{
			mensajeError ='';
			datos.push(nuevoGasto);
		}

		
        // TODO 2: Implementa la lógica de validación y guardado
        // 1. Si nuevoGasto es null -> pon error
        // 2. Si no -> limpia error, haz datos.push(nuevoGasto) y limpia input
    }
</script>

<BaseCard>
	<!--Log de datos para ver que funciona-->
	<!--- Título -->
	<!--- Input y Botón -->
	<!---El valor debe cambiar al hacer click-->
	<!---Mensaje de error-->
    <h3>Añade Movimientos</h3>
		<p> Datos: {datos} </p>
    <div class="input-group">
        <input 
            type="number"
            placeholder="0"
			bind:value={nuevoGasto}
        />
        
        <button onclick={guardar}>
		<!---Hacer como ejercicio con el enter-->
            Guardar
        </button>
        
        <div class="error-msg">
		<p> {mensajeError} </p>
        </div>
      
    </div>
</BaseCard>

<style>
    .input-group { display: flex; gap: 10px; margin-top: 10px; }
    input { padding: 5px; border: 1px solid #FFFFFF; border-radius: 4px; }
    button { cursor: pointer; background-color: black; border: 1px solid #ccc; padding: 5px 10px; border-radius: 4px; }
    .error-msg { color: #dc3545; font-size: 0.85rem; margin-left: 2px; }
</style>
