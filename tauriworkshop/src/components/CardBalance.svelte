<script>
    import BaseCard from './BaseCard.svelte';
    
    // TODO 1: Importa 'datos' desde '../lib/stores.svelte.js'
    
    // TODO 2: Crea la variable 'total' usando $derived
    // Pista: $derived( datos.reduce( ... ) )
    
</script>

<BaseCard>
    <div class="contenedor-balance">
        <h3>Balance Total</h3>
        
        <p class="cifra"> 0 euros</p>
        
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
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    .cifra {
        font-size: 3.5rem; /* ¡Grande y negrita! */
        font-weight: 800;
        margin: 0.5rem 0;
    }

    .etiqueta {
        font-size: 0.8rem;
        background-color: #dcfce7; /* Verde claro fondo */
        color: #166534;            /* Verde oscuro texto */
        padding: 0.25rem 0.75rem;
        border-radius: 999px;      /* Bordes totalmente redondos */
        align-self: flex-start;
        font-weight: 600;
    }
</style>