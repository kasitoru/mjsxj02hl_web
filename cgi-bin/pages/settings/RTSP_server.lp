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
            if fnc.file.is_file(config_file) then
                current_settings = lip.load(config_file)
                current_settings = fnc.table.merge(default_settings, current_settings)
            end
            -- Settings form and logic
            if fnc.string.is_empty(cgilua.POST.action_save) and fnc.string.is_empty(cgilua.POST.action_defaults) then
                %>
                <p class="lead mb-4"><b>RTSP settings</b></p>
                <form method="POST" id="settings_form" class="d-grid gap-2 justify-content-sm-center">
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="enable" name="enable"<% if current_settings.rtsp.enable then cgilua.print(" checked") end %>>
                        <label for="enable" class="form-check-label">Enable RTSP server</label>
                    </div>
                    <div class="form-group text-start">
                        <label for="port" class="form-label">Port number:</label>
                        <input type="text" class="form-control" id="port" name="port" placeholder="<%= default_settings.rtsp.port %>" value="<%= current_settings.rtsp.port %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="username" class="form-label">Username (empty for disable):</label>
                        <input type="text" class="form-control" id="username" name="username" placeholder="<%= default_settings.rtsp.username %>" value="<%= current_settings.rtsp.username %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="password" class="form-label">Password:</label>
                        <input type="password" class="form-control" id="password" name="password" placeholder="<%= default_settings.rtsp.password %>" value="<%= current_settings.rtsp.password %>">
                    </div>
                    <p class="lead mb-0">Primary channel</p>
                    <div class="form-group text-start">
                        <label for="primary_name" class="form-label">Channel name:</label>
                        <input type="text" class="form-control" id="primary_name" name="primary_name" placeholder="<%= default_settings.rtsp.primary_name %>" value="<%= current_settings.rtsp.primary_name %>">
                    </div>
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="primary_multicast" name="primary_multicast"<% if current_settings.rtsp.primary_multicast then cgilua.print(" checked") end %>>
                        <label for="primary_multicast" class="form-check-label">Use multicast</label>
                    </div>
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="primary_split_vframes" name="primary_split_vframes"<% if current_settings.rtsp.primary_split_vframes then cgilua.print(" checked") end %>>
                        <label for="primary_split_vframes" class="form-check-label">Split video frames into separate packets</label>
                    </div>
                    <p class="lead mb-0">Secondary channel</p>
                    <div class="form-group text-start">
                        <label for="secondary_name" class="form-label">Channel name:</label>
                        <input type="text" class="form-control" id="secondary_name" name="secondary_name" placeholder="<%= default_settings.rtsp.secondary_name %>" value="<%= current_settings.rtsp.secondary_name %>">
                    </div>
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="secondary_multicast" name="secondary_multicast"<% if current_settings.rtsp.secondary_multicast then cgilua.print(" checked") end %>>
                        <label for="secondary_multicast" class="form-check-label">Use multicast</label>
                    </div>
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="secondary_split_vframes" name="secondary_split_vframes"<% if current_settings.rtsp.secondary_split_vframes then cgilua.print(" checked") end %>>
                        <label for="secondary_split_vframes" class="form-check-label">Split video frames into separate packets</label>
                    </div>
                    <br>
                    <input type="submit" name="action_save" class="btn btn-primary btn-lg px-4 gap-3" value="Save">
                    <input type="submit" name="action_defaults" class="btn btn-outline-secondary btn-lg px-4" value="Defaults">
                </form>
                <%
            else
                if not fnc.string.is_empty(cgilua.POST.action_save) then
                    if cgilua.POST.enable then current_settings.rtsp.enable = true else current_settings.rtsp.enable = false end
                    current_settings.rtsp.port = lua.tonumber(cgilua.POST.port or default_settings.rtsp.port)
                    current_settings.rtsp.username = (cgilua.POST.username or default_settings.rtsp.username)
                    current_settings.rtsp.password = (cgilua.POST.password or default_settings.rtsp.password)
                    current_settings.rtsp.primary_name = (cgilua.POST.primary_name or default_settings.rtsp.primary_name)
                    if cgilua.POST.primary_multicast then current_settings.rtsp.primary_multicast = true else current_settings.rtsp.primary_multicast = false end
                    if cgilua.POST.primary_split_vframes then current_settings.rtsp.primary_split_vframes = true else current_settings.rtsp.primary_split_vframes = false end
                    current_settings.rtsp.secondary_name = (cgilua.POST.secondary_name or default_settings.rtsp.secondary_name)
                    if cgilua.POST.secondary_multicast then current_settings.rtsp.secondary_multicast = true else current_settings.rtsp.secondary_multicast = false end
                    if cgilua.POST.secondary_split_vframes then current_settings.rtsp.secondary_split_vframes = true else current_settings.rtsp.secondary_split_vframes = false end
                    %>
                    <p class="lead mb-4"><b>RTSP settings saved successfully!</b></p>
                    <%
                elseif not fnc.string.is_empty(cgilua.POST.action_defaults) then
                    current_settings.rtsp = default_settings.rtsp
                    %>
                    <p class="lead mb-4"><b>RTSP successfully reset to factory settings!</b></p>
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
                <a href="/cgi-bin/app.lua/settings/RTSP_server.lp">Return to previous page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
