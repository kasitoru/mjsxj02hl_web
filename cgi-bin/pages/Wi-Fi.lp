<%
lua = required.lua
fnc = required.fnc
os = required.os
%>
<main class="container">
    <div class="bg-light p-5 rounded">
        <div class="text-center">
            <%
            -- Get current and defaults settings
            local config_file = "/configs/wpa_supplicant.conf"
            local default_settings = fnc.app.default_wpa_supplicant()
            local current_settings = default_settings
            if fnc.file.is_file(config_file) then
                current_settings = fnc.file.read_wpa_supplicant(config_file)
                current_settings = fnc.table.merge(default_settings, current_settings)
            end
            -- Settings form and logic
            if fnc.string.is_empty(cgilua.POST.action_save) and fnc.string.is_empty(cgilua.POST.action_defaults) then
                %>
                <p class="lead mb-4"><b>Wi-Fi configuration</b></p>
                <form method="POST" id="settings_form" class="d-grid gap-2 justify-content-sm-center">
                    <input type="hidden" name="scan_ssid" placeholder="<%= default_settings.network.scan_ssid %>" value="<%= current_settings.network.scan_ssid %>">
                    <div class="form-group text-start">
                        <label for="ssid" class="form-label">Service set identifier (SSID):</label>
                        <input type="text" class="form-control" id="ssid" name="ssid" placeholder="<%= default_settings.network.ssid %>" value="<%= current_settings.network.ssid %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="psk" class="form-label">Network key (password):</label>
                        <input type="password" class="form-control" id="psk" name="psk" placeholder="<%= default_settings.network.psk %>" value="<%= current_settings.network.psk %>" data-toggle="password">
                    </div>
                    <br>
                    <input type="submit" name="action_save" class="btn btn-primary btn-lg px-4 gap-3" value="Save">
                    <input type="submit" name="action_defaults" class="btn btn-outline-secondary btn-lg px-4" value="Defaults (AP)">
                </form>
                <%
            else
                if not fnc.string.is_empty(cgilua.POST.action_save) then
                    current_settings.network.scan_ssid = lua.tonumber(cgilua.POST.scan_ssid or default_settings.network.scan_ssid)
                    if current_settings.network.scan_ssid < 0 then current_settings.network.scan_ssid = 0 end
                    if current_settings.network.scan_ssid > 1 then current_settings.network.scan_ssid = 1 end
                    current_settings.network.ssid = (cgilua.POST.ssid or default_settings.network.ssid)
                    current_settings.network.psk = (cgilua.POST.psk or default_settings.network.psk)
                    local wpa_result, wpa_error = fnc.file.save_wpa_supplicant(config_file, current_settings)
                    if wpa_result then
                        %>
                        <p class="lead mb-4"><b>Wi-Fi configuration saved successfully!</b></p>
                        <%
                    else
                        %>
                        <p class="lead mb-4 text-danger"><b><%= wpa_error %>!</b></p>
                        <%
                    end
                elseif not fnc.string.is_empty(cgilua.POST.action_defaults) then
                    local wpa_result, wpa_error = os.remove(config_file)
                    if wpa_result then
                        %>
                        <p class="lead mb-4"><b>Alarm successfully reset to factory settings!</b></p>
                        <%
                    else
                        %>
                        <p class="lead mb-4 text-danger"><b><%= wpa_error %>!</b></p>
                        <%
                    end
                else
                    cgilua.redirect("/")
                    return
                end
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
                    <p class="lead mb-4 text-danger">To apply changes, you need reboot the device.</p>
                    <%
                end
                %>
                <a href="/">Return to main page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
