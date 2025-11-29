<script lang="ts">
    import { scaleLinear } from 'd3-scale';
    import { line, curveMonotoneX,curveStep,curveBasis } from 'd3-shape';
    import {min, max } from 'd3-array';
    import {datos, etiquetas} from '../lib/stores.svelte.js';
    import BaseCard from './BaseCard.svelte';
    // 1. Datos y Etiquetas
    // 2. Dimensiones
    let containerWidth = $state(300);
    let height = 250;
    let margin = { top: 20, right: 20, bottom: 40, left: 40 };
    // 3. Escalas
let xScale = $derived(
        scaleLinear()
            .domain([0, datos.length - 1]) 
            .range([margin.left, containerWidth - margin.right])
    );

    let yScale = $derived(
        scaleLinear()
            .domain([min(datos)||-100 , max(datos) || 100])
            .range([height - margin.bottom, margin.top])
    );

    // 4. Generador de Línea
    let pathD = $derived(
        line<number>()
            .x((_, i) => xScale(i))
            .y((d) => yScale(d))
            .curve(curveMonotoneX)(datos) || "" // Pasamos el valor del store
    );
    //Probar con curveMonotoneX, curveStep, curveBasis
</script>
<BaseCard>
<div class="chart-container" bind:clientWidth={containerWidth}>
    <svg width={containerWidth} {height}>
        <!-- Ejes -->
         {#each yScale.ticks(5) as tick}
        <g transform="translate(0, {yScale(tick)})">
            
            <line 
                x1={margin.left} 
                x2={containerWidth - margin.right} 
                stroke="#eee" 
                stroke-dasharray="4"
            />
            
            <text 
                x={margin.left - 10} 
                y="0" 
                dy="0.32em" 
                text-anchor="end" 
                font-size="11" 
                fill="#999"
            >
                {tick}
            </text>
        </g>
    {/each}

    <line 
        x1={margin.left} 
        y1={margin.top} 
        x2={margin.left} 
        y2={height - margin.bottom} 
        stroke="#ccc" 
    />
        {#each datos as d, i}
            {@const etiquetaActual = etiquetas[i % etiquetas.length]}
            <g transform="translate({xScale(i)}, {height - margin.bottom})">
                <line y2="6" stroke="#ccc" />
                <text 
                    y="20" 
                    text-anchor="middle" 
                    font-size="12" 
                    fill="#666"
                >
                    {etiquetaActual}
                </text>
            </g>
        {/each}

        <path 
            d={pathD} 
            fill="none" 
            stroke="rgb(255, 99, 132)" 
            stroke-width="3" 
            stroke-linecap="round"
        />

        {#each datos as d, i}
            <circle 
                cx={xScale(i)} 
                cy={yScale(d)} 
                r="4" 
                fill="white" 
                stroke="rgb(255, 99, 132)" 
                stroke-width="2"
            />
        {/each}
        
    </svg>
</div>
</BaseCard>
<style>
    .chart-container {
        width: 100%;
        font-family: sans-serif;
    }
</style>