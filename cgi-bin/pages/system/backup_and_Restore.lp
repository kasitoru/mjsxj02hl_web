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
                <p class="lead mb-4"><b>Create and restore a backup of device settings.</b></p>
                <p class="lead mb-4">
                    <form method="POST" class="d-grid gap-2 d-sm-flex justify-content-sm-center">
                        <input type="hidden" name="action" value="create_backup">
                        <input type="submit" class="btn btn-primary btn-lg px-4 gap-3" value="Create Backup">
                    </form>
                </p>
                <p class="lead mb-4">OR</p>
                <p class="lead mb-4">
                    <form method="POST" enctype="multipart/form-data" class="d-grid gap-2 justify-content-sm-center">
                        <input type="hidden" name="action" value="restore_backup">
                        <div class="form-group">
                            <input type="file" class="form-control" name="file">
                        </div>
                        <input type="submit" class="btn btn-primary btn-lg px-4 gap-3" value="Restore Backup">
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
                if cgilua.POST.action == "create_backup" then
                    if os.execute("cat /dev/mtdblock6 > /tmp/configs_backup.bin") then
                        %>
                        <p class="lead mb-4"><b>The backup file was created successfully!</b></p>
                        <p class="lead mb-4" id="download_auto">Download will start automatically after <span id="download_timer">5</span> second(s)...</p>
                        <p class="lead mb-4"><a href="/tmp/configs_backup.bin" id="download_backup">configs_backup.bin</a> (384 Kb)</p>
                        <script type="text/javascript">
                            (function($) {
                                $(document).ready(function() {
                                    var timer_value = $("#download_timer").text();
                                    let timer_id = setInterval(function() {
                                        timer_value--;
                                        $("#download_timer").text(timer_value);
                                        if(timer_value < 1) {
                                            clearInterval(timer_id);
                                            document.getElementById("download_backup").click();
                                        }
                                    }, 1000);
                                    $("a#download_backup").on("click", function() {
                                        clearInterval(timer_id);
                                        $("#download_auto").hide();
                                    });
                                });
                            })(jQuery); 
                        </script>
                        <%
                    else
                        %>
                        <p class="lead mb-4 text-danger"><b>Error creating a backup file!</b></p>
                        <%
                    end
                elseif cgilua.POST.action == "restore_backup" then
                    local post_file = cgilua.POST.file
                    if post_file and post_file.filename and lua.next(post_file) then
                        local backup_length, backup_error = fnc.file.save_post(post_file, "/tmp/configs_backup.bin")
                        if not backup_error then
                            if backup_length == 393216 then
                                if fnc.app.flash_partition("/tmp/configs_backup.bin", "/dev/mtd6") then
                                    %>
                                    <p class="lead mb-4"><b>Restoring the backup copy of the settings was successful!</b></p>
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
                                    <p class="lead mb-4 text-danger"><b>Error restoring a backup copy of the settings!</b></p>
                                    <%
                                end
                            else
                                %>
                                <p class="lead mb-4 text-danger"><b>Invalid size of the backup file!</b></p>
                                <%
                            end
                            os.remove("/tmp/configs_backup.bin")
                        else
                            %>
                            <p class="lead mb-4 text-danger"><b><%= backup_error %>!</b></p>
                            <%
                        end
                    else
                        %>
                        <p class="lead mb-4 text-danger"><b>No backup file selected!</b></p>
                        <%
                    end
                else
                    cgilua.redirect("/")
                    return
                end
                %>
                <a href="/cgi-bin/app.lua/system/backup_and_Restore.lp">Return to previous page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
