<!-- src/components/BaseCard.svelte -->
<div class="card">
<slot />
</div>
<style>
.card {
background: #ffffff;
border-radius: 16px;
box-shadow: 0 4px 20px rgba(0,0,0,0.08);
padding: 1.5rem;
height: 100%;
display: flex;
flex-direction: column;
justify-content: space-between;
}
</style>