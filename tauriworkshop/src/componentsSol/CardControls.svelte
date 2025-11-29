<script lang="ts">
    import BaseCard from './BaseCard.svelte';
    import { datos, etiquetas } from '../lib/stores.svelte.js'; 

    // 1. VARIABLE REACTIVA ($state)
    // En Svelte 5, las variables locales necesitan $state para reaccionar.
	let nuevoGasto = $state<number | null>(null);
	let mensajeerror= $state<string>("");

    function guardar() {
        // Validación simple: que sea número y que no esté vacío
        if (nuevoGasto === null ) 
			{mensajeerror="Por favor, ingresa un valor numérico válido.";
			return;}
		else{
			mensajeerror="";
			datos.push(nuevoGasto);
			nuevoGasto = null;
}}
</script>

<BaseCard>
    <h3>Añade Movimientos</h3>
    <div class="input-group">
        <input 
            type="number" 
            placeholder="0"
            bind:value={nuevoGasto} 
            onkeydown={(e)=>{if(e.key == 'Enter'){guardar();}}}
        />
        <button onclick={guardar} >
            Guardar
        </button>
        
		<div class="error-msg">
			{mensajeerror}
	    </div>
      
    </div>
</BaseCard>

<style>
    .input-group {
        display: flex;
        gap: 10px;
        margin-top: 10px;
    }
    input {
        padding: 5px;
        border: 1px solid #ccc;
        border-radius: 4px;
    }
    button {
        cursor: pointer;
        background-color: #eee;
        border: 1px solid #ccc;
        padding: 5px 10px;
        border-radius: 4px;
    }
    .error-msg {
        color: #dc3545;
        font-size: 0.85rem;
        margin-left: 2px;
        animation: fadeIn 0.3s ease-in;
    }
</style>