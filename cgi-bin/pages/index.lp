<script type="text/javascript">
    let update_status = null;
    function switch_update() {
        if(update_status) {
            clearInterval(update_status);
            update_status = null;
            $("#switch_button").removeClass("btn-primary").addClass("btn-secondary").text("Start refresh");
        } else {
            update_status = setInterval(function() {
                $("#camera_image").attr("src", "/cgi-bin/get_image.cgi?random=" + new Date().getTime());
            }, 1000);
            $("#switch_button").removeClass("btn-secondary").addClass("btn-primary").text("Stop refresh");
        }
    }
</script>
<main class="container">
    <div class="bg-light p-5 rounded">
        <div class="text-center">
            <h1>Xiaomi Mi Home Security Camera</h1>
            <p><img id="camera_image" src="/cgi-bin/get_image.cgi" alt="Image" width="640" height="360"></p>
            <p>
                <button id="switch_button" class="btn btn-lg btn-secondary" onclick="switch_update()" role="button">Start refresh</button>
            </p>
        </div>
    </div>
</main>
