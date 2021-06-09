<%
os = required.os
lua = required.lua
fnc = required.fnc
%>
<main class="container">
    <div class="bg-light p-5 rounded">
        <div class="text-center">
            <%
            if fnc.string.is_empty(cgilua.POST.action) then
                %>
                <p class="lead mb-4"><b>Download and upgrade the bootloader.</b></p>
                <p class="lead mb-4 text-danger">Warning: this can ruin your device!</p>
                <p class="lead mb-4">
                    <form method="POST" class="d-grid gap-2 d-sm-flex justify-content-sm-center">
                        <input type="hidden" name="action" value="bootloader_download">
                        <input type="submit" class="btn btn-primary btn-lg px-4 gap-3" value="Download Bootloader">
                    </form>
                </p>
                <p class="lead mb-4">OR</p>
                <p class="lead mb-4">
                    <form method="POST" enctype="multipart/form-data" class="d-grid gap-2 justify-content-sm-center">
                        <input type="hidden" name="action" value="bootloader_upgrade">
                        <div class="form-group">
                            <input type="file" class="form-control" name="file">
                        </div>
                        <input type="submit" class="btn btn-primary btn-lg px-4 gap-3" value="Upgrade Bootloader">
                    </form>
                </p>
                <script type="text/javascript">
                    (function($) {
                        $(document).ready(function() {
                            $("form").on("submit", function(e) {
                                $(e.target).find("input[type=submit]").prop('disabled', true);
                            });
                        });
                    })(jQuery); 
                </script>
                <%
            else
                if cgilua.POST.action == "bootloader_download" then
                    if os.execute("cat /dev/mtdblock0 > /tmp/bootloader.bin") then
                        %>
                        <p class="lead mb-4"><b>The bootloader file was created successfully!</b></p>
                        <p class="lead mb-4" id="download_auto">Download will start automatically after <span id="download_timer">5</span> second(s)...</p>
                        <p class="lead mb-4"><a href="/tmp/bootloader.bin" id="download_bootloader">bootloader.bin</a> (256 Kb)</p>
                        <script type="text/javascript">
                            (function($) {
                                $(document).ready(function() {
                                    var timer_value = $("#download_timer").text();
                                    let timer_id = setInterval(function() {
                                        timer_value--;
                                        $("#download_timer").text(timer_value);
                                        if(timer_value < 1) {
                                            clearInterval(timer_id);
                                            document.getElementById("download_bootloader").click();
                                        }
                                    }, 1000);
                                    $("a#download_bootloader").on("click", function() {
                                        clearInterval(timer_id);
                                        $("#download_auto").hide();
                                    });
                                });
                            })(jQuery); 
                        </script>
                        <%
                    else
                        %>
                        <p class="lead mb-4 text-danger"><b>Error creating a bootloader file!</b></p>
                        <%
                    end
                elseif cgilua.POST.action == "bootloader_upgrade" then
                    local post_file = cgilua.POST.file
                    if post_file and post_file.filename and lua.next(post_file) then
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
                                            (function($) {
                                                $(document).ready(function() {
                                                    var timer_value = $("#wait_timer").text();
                                                    let timer_id = setInterval(function() {
                                                        timer_value--;
                                                        $("#wait_timer").text(timer_value);
                                                        if(timer_value < 1) {
                                                            clearInterval(timer_id);
                                                            window.location.replace("/");
                                                        }
                                                    }, 1000);
                                                });
                                            })(jQuery); 
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
