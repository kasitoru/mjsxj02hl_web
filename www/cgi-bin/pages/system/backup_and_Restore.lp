<%
os = required.os
lua = required.lua
fnc = required.fnc
%>
<main class="container">
    <div class="bg-light p-5 rounded">
        <div class="text-center">
            <%
            if fnc.string.is_empty(cgilua.POST.create_backup) and fnc.string.is_empty(cgilua.POST.restore_backup) then
                %>
                <p class="lead mb-4"><b>Create and restore a backup of device settings.</b></p>
                <p class="lead mb-4">
                    <form method="POST" class="d-grid gap-2 d-sm-flex justify-content-sm-center">
                        <input type="submit" name="create_backup" class="btn btn-primary btn-lg px-4 gap-3" value="Create Backup">
                    </form>
                </p>
                <p class="lead mb-4">OR</p>
                <p class="lead mb-4">
                    <form method="POST" enctype="multipart/form-data" class="d-grid gap-2 justify-content-sm-center">
                        <div class="form-group">
                            <input type="file" class="form-control" name="file">
                        </div>
                        <input type="submit" name="restore_backup" class="btn btn-primary btn-lg px-4 gap-3" value="Restore Backup" onclick="setTimeout(() => this.setAttribute('disabled', true), 0);">
                    </form>
                </p>
                <%
            else
                if not fnc.string.is_empty(cgilua.POST.create_backup) then
                    if os.execute("cat /dev/mtdblock6 > /tmp/configs_backup.bin") then
                        %>
                        <p class="lead mb-4"><b>The backup file was created successfully!</b></p>
                        <p class="lead mb-4" id="download_auto">Download will start automatically after <span id="download_timer">5</span> second(s)...</p>
                        <p class="lead mb-4"><a href="/tmp/configs_backup.bin" id="download_backup">configs_backup.bin</a> (384 Kb)</p>
                        <script type="text/javascript">
                            (function() {
                                document.addEventListener("DOMContentLoaded", function(event) {
                                    var download_element = document.getElementById("download_backup");
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
                        <p class="lead mb-4 text-danger"><b>Error creating a backup file!</b></p>
                        <%
                    end
                elseif not fnc.string.is_empty(cgilua.POST.restore_backup) then
                    local post_file = cgilua.POST.file
                    if post_file and (not fnc.string.is_empty(post_file.filename)) and lua.next(post_file) then
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
