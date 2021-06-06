<%
io = required.io
os = required.os
lua = required.lua
fnc = required.fnc
%>
<main class="container">
    <div class="bg-light p-5 rounded">
        <div class="text-center">
            <%
            if fnc.string.is_empty(cgilua.POST.file) then
                %>
                <p class="lead mb-4"><b>Upgrade the device firmware.</b></p>
                <%
                local version = fnc.file.get_contents("/usr/app/share/.version")
                if fnc.string.is_empty(version) then
                    version = "Unknown"
                end
                %>
                <p class="lead mb-4">Current version: <%= version %></p>
                <%
                if fnc.file.exists("/dev/mmcblk0") then
                    %>
                    <p class="lead mb-4">
                        <form method="POST" enctype="multipart/form-data" class="d-grid gap-2 justify-content-sm-center">
                            <div class="form-group">
                                <input type="file" class="form-control" name="file">
                            </div>
                            <input type="submit" class="btn btn-primary btn-lg px-4 gap-3" value="Upgrade firmware">
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
                    %>
                    <p class="lead mb-4 text-danger">To update the firmware, you need a SD card!</p>
                    <%
                end
            else
                local post_file = cgilua.POST.file
                if post_file and post_file.filename and lua.next(post_file) then
                    local firmware_length, firmware_error = fnc.file.save_post(post_file, "/mnt/mmc/demo_hlc6.bin")
                    if not firmware_error then
                        if firmware_length == 12058688 then
                            if os.execute("reboot") then
                                %>
                                <p class="lead mb-4"><b>Firmware has been successfully saved to the memory card!</b></p>
                                <%
                            end
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
                            <p class="lead mb-4"><b>Invalid size of the firmware file!</b></p>
                            <%
                        end
                    else
                        %>
                        <p class="lead mb-4"><b><%= firmware_error %>!</b></p>
                        <%
                    end
                else
                    %>
                    <p class="lead mb-4"><b>No firmware file selected!</b></p>
                    <%
                end
                %>
                <a href="/cgi-bin/app.lua/system/firmware_upgrade.lp">Return to previous page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
