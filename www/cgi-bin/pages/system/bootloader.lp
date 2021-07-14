<%
os = required.os
lua = required.lua
fnc = required.fnc
%>
<main class="container">
    <div class="bg-light p-5 rounded">
        <div class="text-center">
            <%
            if fnc.string.is_empty(cgilua.POST.bootloader_download) and fnc.string.is_empty(cgilua.POST.bootloader_upgrade) then
                %>
                <p class="lead mb-4"><b>Download and upgrade the bootloader.</b></p>
                <p class="lead mb-4 text-danger">Warning: this can ruin your device!</p>
                <p class="lead mb-4">
                    <form method="POST" class="d-grid gap-2 d-sm-flex justify-content-sm-center">
                        <input type="submit" name="bootloader_download" class="btn btn-primary btn-lg px-4 gap-3" value="Download Bootloader">
                    </form>
                </p>
                <p class="lead mb-4">OR</p>
                <p class="lead mb-4">
                    <form method="POST" enctype="multipart/form-data" class="d-grid gap-2 justify-content-sm-center">
                        <div class="form-group">
                            <input type="file" class="form-control" name="file">
                        </div>
                        <input type="submit" name="bootloader_upgrade" class="btn btn-primary btn-lg px-4 gap-3" value="Upgrade Bootloader" onclick="setTimeout(() => this.setAttribute('disabled', true), 0);">
                    </form>
                </p>
                <%
            else
                if not fnc.string.is_empty(cgilua.POST.bootloader_download) then
                    if os.execute("cat /dev/mtdblock0 > /tmp/bootloader.bin") then
                        %>
                        <p class="lead mb-4"><b>The bootloader file was created successfully!</b></p>
                        <p class="lead mb-4" id="download_auto">Download will start automatically after <span id="download_timer">5</span> second(s)...</p>
                        <p class="lead mb-4"><a href="/tmp/bootloader.bin" id="download_bootloader">bootloader.bin</a> (256 Kb)</p>
                        <script type="text/javascript">
                            (function() {
                                document.addEventListener("DOMContentLoaded", function(event) {
                                    var download_element = document.getElementById("download_bootloader");
                                    var timer_element = document.getElementById("download_timer");
                                    var timer_value = timer_element.textContent || timer_element.innerText;
                                    let timer_id = setInterval(function() {
                                        timer_value--;
                                        timer_element.textContent = timer_value;
                                        if(timer_value < 1) {
                                            clearInterval(timer_id);
                                            download_element.click();
                                        }
                                    }, 1000);
                                    download_element.addEventListener("click", function(e) {
                                        clearInterval(timer_id);
                                        document.getElementById("download_auto").style.display = "none";
                                    }, false);
                                });
                            })();
                        </script>
                        <%
                    else
                        %>
                        <p class="lead mb-4 text-danger"><b>Error creating a bootloader file!</b></p>
                        <%
                    end
                elseif not fnc.string.is_empty(cgilua.POST.bootloader_upgrade) then
                    local post_file = cgilua.POST.file
                    if post_file and (not fnc.string.is_empty(post_file.filename)) and lua.next(post_file) then
                        local bootloader_length, bootloader_error = fnc.file.save_post(post_file, "/tmp/bootloader.bin")
                        if not bootloader_error then
                            if bootloader_length == 262144 then
                                if fnc.app.flash_partition("/tmp/bootloader.bin", "/dev/mtd0") then
                                    %>
                                    <p class="lead mb-4"><b>Bootloader is successfully upgraded!</b></p>
                                    <%
                                    if os.execute("reboot") then
                                        %>
                                        <p class="lead mb-4"><b>The device is being rebooted, it may take some time.</b></p>
                                        <p class="lead mb-4">Wait <span id="wait_timer">30</span> second(s)...</p>
                                        <script type="text/javascript">
                                            (function() {
                                                document.addEventListener("DOMContentLoaded", function(event) {
                                                    var timer_element = document.getElementById("wait_timer");
                                                    var timer_value = timer_element.textContent || timer_element.innerText;
                                                    let timer_id = setInterval(function() {
                                                        timer_value--;
                                                        timer_element.textContent = timer_value;
                                                        if(timer_value < 1) {
                                                            clearInterval(timer_id);
                                                            window.location.replace("/");
                                                        }
                                                    }, 1000);
                                                });
                                            })();
                                        </script>
                                        <%
                                    else
                                        %>
                                        <p class="lead mb-4 text-danger">To apply changes, you need <a href="/cgi-bin/app.lua/system/reboot.lp">reboot</a> the device.</p>
                                        <%
                                    end
                                else
                                    %>
                                    <p class="lead mb-4 text-danger"><b>Bootloader update error!</b></p>
                                    <%
                                end
                            else
                                %>
                                <p class="lead mb-4 text-danger"><b>Invalid size of the bootloader file!</b></p>
                                <%
                            end
                            os.remove("/tmp/bootloader.bin")
                        else
                            %>
                            <p class="lead mb-4 text-danger"><b><%= bootloader_error %>!</b></p>
                            <%
                        end
                    else
                        %>
                        <p class="lead mb-4 text-danger"><b>No bootloader file selected!</b></p>
                        <%
                    end
                else
                    cgilua.redirect("/")
                    return
                end
                %>
                <a href="/cgi-bin/app.lua/system/bootloader.lp">Return to previous page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
