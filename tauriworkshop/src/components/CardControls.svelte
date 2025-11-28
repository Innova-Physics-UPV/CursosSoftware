<script>
	import BaseCard from './BaseCard.svelte';
	import { datos, etiquetas } from '../lib/stores.js';

	let nuevoGasto = '';

	function guardar() {
        
		datos.update((arr) => {
            const next = [...arr, valor];
            return next;
		});
		etiquetas.update((arr) => {
        //Completar 
		});
		nuevoGasto = '';
	}
//
</script>

<BaseCard>
	<h3>Add Moves</h3>
	<div class="input-group">
		<input type="number" bind:value={nuevoGasto} />
		<button on:click={guardar}>Guardar</button>
	</div>
</BaseCard>