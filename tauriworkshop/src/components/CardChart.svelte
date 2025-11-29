<script lang="ts">
    import { scaleLinear } from 'd3-scale';
    import { line, curveMonotoneX, curveStep, curveBasis } from 'd3-shape';
    import { min, max } from 'd3-array';
    //import { datos, etiquetas } from '../lib/stores.svelte.js';
    import BaseCard from './BaseCard.svelte';

    // --- 1. CONFIGURACIÓN ---
    // Dimensiones del gráfico
    let containerWidth = $state(300); // Ancho reactivo
    let height = 250;
    let margin = { top: 20, right: 20, bottom: 40, left: 40 };

    // --- 2. LÓGICA (A REALIZAR) ---
    
    // TODO 1: Crear Escala X ($derived)
    // Debe mapear el índice del array (0, 1, 2...) a píxeles horizontales
    
    // TODO 2: Crear Escala Y ($derived)
    // Debe mapear el valor monetario (min a max) a píxeles verticales
    
    // TODO 3: Generador de Línea ($derived)
    // Debe usar d3.line() con las escalas anteriores para crear el "path"

</script>

<BaseCard>
    <div class="chart-container" bind:clientWidth={containerWidth}>
        
        <svg width={containerWidth} {height}>
            
            </svg>

    </div>
</BaseCard>

<style>
    .chart-container {
        width: 100%;
        font-family: sans-serif;
    }
</style>