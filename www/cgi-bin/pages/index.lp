<script type="text/javascript">
    let update_status = null;
    function switch_update() {
        var switch_button = document.getElementById("switch_button");
        if(update_status) {
            clearInterval(update_status);
            update_status = null;
            switch_button.classList.remove("btn-primary");
            switch_button.classList.add("btn-secondary");
            switch_button.textContent = "Start refresh"
        } else {
            update_status = setInterval(function() {
                document.getElementById("camera_image").src = "/cgi-bin/get_image.cgi?random=" + new Date().getTime();
            }, 1000);
            switch_button.classList.remove("btn-secondary");
            switch_button.classList.add("btn-primary");
            switch_button.textContent = "Stop refresh"
        }
    }
</script>
<main class="container">
    <div class="bg-light p-5 rounded">
        <div class="text-center">
            <h1>Xiaomi Mi Home Security Camera</h1>
            <p><img id="camera_image" src="/cgi-bin/get_image.cgi" alt="Image" width="100%" height="100%"></p>
            <p>
                <button id="switch_button" class="btn btn-lg btn-secondary" onclick="switch_update()" role="button">Start refresh</button>
            </p>
        </div>
    </div>
</main>
