<script>
    import { onDestroy } from 'svelte';
    import { scaleLinear, scalePoint } from 'd3-scale';
    import { line, curveMonotoneX } from 'd3-shape';
    import { max } from 'd3-array';
    import { spring } from 'svelte/motion';

    // Use shared stores
    import { datos, etiquetas } from '../lib/stores.js';

    // Local layout state
    let width = 600;
    let height = 300;
    let puntoSeleccionado = null;
    const margin = { top: 20, right: 20, bottom: 30, left: 40 };

    // Animated visual store (spring) and sync with datos store
    const datosVisuales = spring([], { stiffness: 0.1, damping: 0.4 });
    const unsubDatos = datos.subscribe((v) => {
        datosVisuales.set(v || []);
    });

    // Keep etiquetas in a local array for scale domains
    let etiquetasArr = [];
    const unsubEtiquetas = etiquetas.subscribe((v) => {
        etiquetasArr = v || [];
    });

    onDestroy(() => {
        unsubDatos();
        unsubEtiquetas();
    });

    // Reactive D3 scales / generators
    $: xScale = scalePoint().domain(etiquetasArr.length ? etiquetasArr : datosPositions($datosVisuales.length)).range([margin.left, width - margin.right]);
    $: yScale = scaleLinear().domain([0, max($datosVisuales) || 100]).range([height - margin.bottom, margin.top]);

    // Precompute x positions so we can fallback when etiquetasArr is missing or mismatched
    $: xPositions = (etiquetasArr.length === $datosVisuales.length)
        ? etiquetasArr.map((l) => xScale(l))
        : $datosVisuales.map((_, i) => margin.left + (i * ((width - margin.left - margin.right) / Math.max(1, $datosVisuales.length - 1))));

    $: lineaGenerator = line().x((d, i) => xPositions[i]).y((d) => yScale(d)).curve(curveMonotoneX);
    $: pathD = $datosVisuales && $datosVisuales.length ? lineaGenerator($datosVisuales) : '';

    $: tooltipLeft = puntoSeleccionado !== null ? xPositions[puntoSeleccionado] : 0;
    $: tooltipTop = puntoSeleccionado !== null && $datosVisuales[puntoSeleccionado] !== undefined ? yScale($datosVisuales[puntoSeleccionado]) - 40 : 0;

    function datosPositions(n) {
        // Return placeholder domain values for scalePoint if needed
        return Array.from({ length: Math.max(1, n) }, (_, i) => String(i));
    }
</script>

<div class="chart-container" bind:clientWidth={width}>
    <svg {width} {height} role="img" aria-label="Gráfico de gastos">
        <!-- Eje X -->
        <g class="axis x-axis">
            {#if etiquetasArr.length}
                {#each etiquetasArr as lab, i}
                    <g transform={"translate(" + xPositions[i] + ", " + (height - margin.bottom) + ")"}>
                        <line y2="6" stroke="#ccc" />
                        <text y="20" text-anchor="middle" font-size="12" fill="#666">{lab}</text>
                    </g>
                {/each}
            {/if}
        </g>

        <!-- LÍNEA DE DATOS (Morphing) -->
        <path d={pathD} fill="none" stroke="rgb(255, 99, 132)" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" style="transition: stroke 0.3s;" />

        <!-- PUNTOS INTERACTIVOS -->
        {#each $datosVisuales as d, i}
            <circle
                role="button"
                tabindex="0"
            cx={xPositions[i]}
                cy={yScale(d)}
                r={puntoSeleccionado === i ? 8 : 5}
                fill="white"
                stroke="rgb(255, 99, 132)"
                stroke-width="2"
                on:mouseenter={() => (puntoSeleccionado = i)}
                on:mouseleave={() => (puntoSeleccionado = null)}
                style="cursor: pointer; transition: r 0.2s cubic-bezier(0.25, 0.46, 0.45, 0.94);"
            />
        {/each}
    </svg>

    {#if puntoSeleccionado !== null}
        <div
            class="tooltip"
            style="left: {tooltipLeft}px; top: {tooltipTop}px;"
        >
            <strong>{etiquetasArr[puntoSeleccionado]}</strong>: {Math.round($datosVisuales[puntoSeleccionado])}
        </div>
    {/if}
</div>

<style>
    .chart-container {
        position: relative;
        width: 100%;
    }

    .tooltip {
        position: absolute;
        transform: translateX(-50%);
        background: #333;
        color: #fff;
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 0.8rem;
        pointer-events: none;
        white-space: nowrap;
        z-index: 10;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
    }
</style>