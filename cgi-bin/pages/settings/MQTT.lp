<%
lua = required.lua
lip = required.lip
fnc = required.fnc
%>
<main class="container">
    <div class="bg-light p-5 rounded">
        <div class="text-center">
            <%
            -- Get current and defaults settings
            local config_file = "/usr/app/share/mjsxj02hl.conf"
            local default_settings = fnc.app.default_settings()
            local current_settings = default_settings
            if fnc.file.is_file(config_file) and fnc.file.exists(config_file) then
                current_settings = lip.load(config_file)
                current_settings = fnc.table.merge(default_settings, current_settings)
            end
            -- Settings form and logic
            if fnc.string.is_empty(cgilua.POST.action) then
                %>
                <p class="lead mb-4"><b>MQTT settings</b></p>
                <form method="POST" id="settings_form" class="d-grid gap-2 justify-content-sm-center">
                    <div class="form-group text-start">
                        <label for="server" class="form-label">Server address (empty for disable):</label>
                        <input type="text" class="form-control" id="server" name="server" placeholder="<%= default_settings.mqtt.server %>" value="<%= current_settings.mqtt.server %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="port" class="form-label">Port number:</label>
                        <input type="text" class="form-control" id="port" name="port" placeholder="<%= default_settings.mqtt.port %>" value="<%= current_settings.mqtt.port %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="username" class="form-label">Username (empty for anonimous):</label>
                        <input type="text" class="form-control" id="username" name="username" placeholder="<%= default_settings.mqtt.username %>" value="<%= current_settings.mqtt.username %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="password" class="form-label">Password (empty for disable):</label>
                        <input type="password" class="form-control" id="password" name="password" placeholder="<%= default_settings.mqtt.password %>" value="<%= current_settings.mqtt.password %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="topic" class="form-label">Topic name:</label>
                        <input type="text" class="form-control" id="topic" name="topic" placeholder="<%= default_settings.mqtt.topic %>" value="<%= current_settings.mqtt.topic %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="qos" class="form-label">Quality of Service:</label>
                        <select class="form-select" id="qos" name="qos">
                            <option value="0"<% if current_settings.mqtt.qos == 0 then cgilua.print(" selected") end %>>At most once (fire and forget)</option>
                            <option value="1"<% if current_settings.mqtt.qos == 1 then cgilua.print(" selected") end %>>At least once</option>
                            <option value="2"<% if current_settings.mqtt.qos == 2 then cgilua.print(" selected") end %>>Once only</option>
                        </select>
                    </div>
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="retain" name="retain"<% if current_settings.mqtt.retain then cgilua.print(" checked") end %>>
                        <label for="retain" class="form-check-label">Retained messages</label>
                    </div>
                    <br>
                    <input type="hidden" id="action_value" name="action" value="">
                    <input type="button" id="action_save" class="btn btn-primary btn-lg px-4 gap-3" value="Save">
                    <input type="button" id="action_defaults" class="btn btn-outline-secondary btn-lg px-4" value="Defaults">
                </form>
                <script type="text/javascript">
                    (function($) {
                        $(document).ready(function() {
                            var settings_form = $("form#settings_form")
                            $(settings_form).find("input[type=button]").filter("#action_save,#action_defaults").on("click", function(e) {
                                $(settings_form).find("input#action_value").val(e.target.id);
                                settings_form.submit();
                            });
                            $(settings_form).find("input[type=password]").password();
                        });
                    })(jQuery); 
                </script>
                <%
            else
                if cgilua.POST.action == "action_save" then
                    current_settings.mqtt.server   = (cgilua.POST.server or default_settings.mqtt.server)
                    current_settings.mqtt.port     = lua.tonumber(cgilua.POST.port or default_settings.mqtt.port)
                    current_settings.mqtt.username = (cgilua.POST.username or default_settings.mqtt.username)
                    current_settings.mqtt.password = (cgilua.POST.password or default_settings.mqtt.password)
                    current_settings.mqtt.topic    = (cgilua.POST.topic or default_settings.mqtt.topic)
                    current_settings.mqtt.qos      = lua.tonumber(cgilua.POST.qos or default_settings.mqtt.qos)
                    if current_settings.mqtt.qos < 0 then current_settings.mqtt.qos = 0 end
                    if current_settings.mqtt.qos > 2 then current_settings.mqtt.qos = 2 end
                    if cgilua.POST.retain then current_settings.mqtt.retain = true else current_settings.mqtt.retain = false end
                    %>
                    <p class="lead mb-4"><b>MQTT settings saved successfully!</b></p>
                    <%
                elseif cgilua.POST.action == "action_defaults" then
                    current_settings.mqtt = default_settings.mqtt
                    %>
                    <p class="lead mb-4"><b>MQTT successfully reset to factory settings!</b></p>
                    <%
                else
                    cgilua.redirect("/")
                    return
                end
                lip.save(config_file, current_settings);
                if not fnc.app.restart() then
                    %>
                    <p class="lead mb-4 text-danger">Error restarting the MJSXJ02HL application!<br>Please <a href="/cgi-bin/app.lua/system/reboot.lp">reboot</a> your device manually.</p>
                    <%
                end
                %>
                <a href="/cgi-bin/app.lua/settings/MQTT.lp">Return to previous page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
