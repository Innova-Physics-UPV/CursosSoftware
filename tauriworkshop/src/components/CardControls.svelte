<script>
	import BaseCard from './BaseCard.svelte';
	import { datos, etiquetas } from '../lib/stores.js';

	let nuevoGasto = '';

	function guardar() {
		const valor = Number(nuevoGasto);
		if (isNaN(valor)) return;

		// Añadimos al store de datos y creamos una etiqueta simple
		datos.update((arr) => {
			const next = [...arr, valor];
			return next;
		});

		etiquetas.update((arr) => {
			const next = [...arr, `N${arr.length + 1}`];
			return next;
		});

		nuevoGasto = '';
	}
</script>

<BaseCard>
	<h3>Add Moves</h3>
	<div class="input-group">
		<input type="number" bind:value={nuevoGasto} />
		<button on:click={guardar}>Guardar</button>
	</div>
</BaseCard>