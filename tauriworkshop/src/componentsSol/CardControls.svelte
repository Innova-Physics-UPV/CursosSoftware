<script>
	import BaseCard from './BaseCard.svelte';
	import { datos, etiquetas } from '../lib/stores.js'; //Donde estan guardados los datos

	//Declarar variable para guardar el input del usuario

	function guardar() {
		//Que ocurre si el usuario no introduce un número válido?
		//const valor = ...; //El input es un string, hay que convertirlo a número

		// Añadimos al store de datos y creamos una etiqueta simple
		datos.update((arr) => {
			//const next = [...arr, valor];//añadimos un nuevo valor al array
			//return next; 				//retornamos el nuevo array
		});

		etiquetas.update((arr) => {
			//Completar, ¿Que valor queremos añadir?
		});
	}
</script>

<BaseCard>
	<h3>Add Moves</h3>
	<div class="input-group">
		<input type="number"/><!---Guardar este input en una variable. PISTA:bind en documentación de svelte---> 
		<button >Guardar</button><!---Ejecutar logica cuando se presione un boton PISTA:onClick en documentación de sveltes---> 
	</div>
</BaseCard>