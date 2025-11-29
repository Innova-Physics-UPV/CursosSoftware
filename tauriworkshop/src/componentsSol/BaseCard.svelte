<div class="card">
  <slot /> <!-- Aquí se inyecta el contenido -->
</div>
<style>
  .card {
    /* --- 1. FONDO Y EFECTOS --- */
    background: #ffffff; 
    border: 2px solid #f32222;

    /* PRUEBA ESTOS FONDOS: */
    /*background: #1a1a1a;/* (Modo oscuro) */
    /* background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); (Gradiente) */

    /*(Efecto Cristal): */
    /* Descomenta las 2 lineas de abajo y comenta el background solido de arriba */
    background: rgba(255, 255, 255, 0.5);/* */
    backdrop-filter: blur(12px); /**/

    border-radius: 1px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    /* PRUEBA: Cambia el color de la sombra a azul: rgba(0, 100, 255, 0.2) */
    padding: 1.5rem;
    height: 100%;
    /* --- 2. DISPOSICIÓN (FLEXBOX) --- */
    display: flex;
    flex-direction: column;
    /* PRUEBA: Cambia a 'row' para poner elementos uno al lado del otro */
    justify-content: space-between;
    /* PRUEBA: center, flex-start, flex-end, space-around */
    align-items: center; 
  }
</style>