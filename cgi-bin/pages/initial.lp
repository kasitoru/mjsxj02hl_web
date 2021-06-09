<%
lua = required.lua
fnc = required.fnc
os = required.os
%>
<!doctype html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>MJSXJ02HL: <%= page_info.title %></title>
        <link rel="icon" href="/favicon.ico">
        <link rel="stylesheet" href="/style.css">
    </head>
    <body>
        <div class="initial-lp-container">
            <div class="initial-lp-content">
                <%
                -- Get defaults settings
                local config_file = "/configs/wpa_supplicant.conf"
                local default_settings = fnc.app.default_wpa_supplicant()
                -- Settings form and logic
                if fnc.string.is_empty(cgilua.POST.save) then
                    %>
                    <p><b>Wi-Fi configuration</b></p>
                    <form method="POST" id="settings_form">
                        <input type="hidden" name="scan_ssid" value="<%= default_settings.network.scan_ssid %>">
                        <label for="ssid">Service set identifier (SSID):</label>
                        <input type="text" name="ssid" placeholder="<%= default_settings.network.ssid %>">
                        <label for="psk">Network key (password):</label>
                        <input type="password" name="psk" placeholder="<%= default_settings.network.psk %>">
                        <br>
                        <input type="submit" name="save" value="Save">
                    </form>
                    <%
                else
                    local current_settings = fnc.table.merge(default_settings, {})
                    current_settings.network.scan_ssid = lua.tonumber(cgilua.POST.scan_ssid or default_settings.network.scan_ssid)
                    if current_settings.network.scan_ssid < 0 then current_settings.network.scan_ssid = 0 end
                    if current_settings.network.scan_ssid > 1 then current_settings.network.scan_ssid = 1 end
                    current_settings.network.ssid = (cgilua.POST.ssid or default_settings.network.ssid)
                    current_settings.network.psk = (cgilua.POST.psk or default_settings.network.psk)
                    local wpa_result, wpa_error = fnc.file.save_wpa_supplicant(config_file, current_settings)
                    if wpa_result then
                        %>
                        <p><b>Wi-Fi configuration saved successfully!</b></p>
                        <%
                    else
                        %>
                        <p class="text-danger"><b><%= wpa_error %>!</b></p>
                        <%
                    end
                    if os.execute("reboot") then
                        %>
                        <p><b>The device is being rebooted, it may take some time.</b></p>
                        <p>Wait <span id="wait_timer">30</span> second(s)...</p>
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
                        <p class="text-danger">To apply changes, you need reboot the device.</p>
                        <%
                    end
                    %>
                    <a href="/">Return to main page</a>
                    <%
                end
                %>
            </div>
        </div>
    </body>
</html>
