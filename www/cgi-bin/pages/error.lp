<style>
    html, body {
        height: 100%;
    }
    body {
        display: flex;
        align-items: center;
        padding-bottom: 100px;
        background-color: #f5f5f5;
    }
    .error-block {
        width: 100%;
        max-width: 330px;
        padding: 15px;
        margin: auto;
    }
</style>
<main class="error-block text-center">
    <h1 class="h3 mb-3 fw-normal"><%= page_info.title %></h1>
    <div class="alert alert-danger" role="alert"><%= page_info.message %></div>
    <a href="/">Return to main page</a>
</main>
