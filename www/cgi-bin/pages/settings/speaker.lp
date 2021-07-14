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
                <p class="lead mb-4"><b>Speaker settings</b></p>
                <form method="POST" id="settings_form" class="d-grid gap-2 justify-content-sm-center">
                    <div class="form-group text-start">
                        <label for="type" class="form-label">Default file format:</label>
                        <select class="form-select" id="type" name="type">
                            <option value="1"<% if current_settings.speaker.type == 1 then cgilua.print(" selected") end %>>PCM (WAV, 8000 hz, 16-bit, mono)</option>
                            <option value="2"<% if current_settings.speaker.type == 2 then cgilua.print(" selected") end %>>G711 (A-Law, 8000 hz, 16-bit, mono)</option>
                        </select>
                    </div>
                    <div class="form-group text-start">
                        <label for="volume" class="form-label">Volume level (0-100):</label>
                        <input type="text" class="form-control" id="volume" name="volume" placeholder="<%= default_settings.speaker.volume %>" value="<%= current_settings.speaker.volume %>">
                    </div>
                    <br>
                    <input type="submit" name="action_save" class="btn btn-primary btn-lg px-4 gap-3" value="Save">
                    <input type="submit" name="action_defaults" class="btn btn-outline-secondary btn-lg px-4" value="Defaults">
                </form>
                <%
            else
                if not fnc.string.is_empty(cgilua.POST.action_save) then
                    current_settings.speaker.type = fnc.number.boundaries(lua.tonumber(cgilua.POST.type or default_settings.speaker.type), 1, 2)
                    current_settings.speaker.volume = fnc.number.boundaries(lua.tonumber(cgilua.POST.volume or default_settings.speaker.volume), 0, 100)
                    %>
                    <p class="lead mb-4"><b>Speaker settings saved successfully!</b></p>
                    <%
                elseif not fnc.string.is_empty(cgilua.POST.action_defaults) then
                    current_settings.speaker = default_settings.speaker
                    %>
                    <p class="lead mb-4"><b>Speaker successfully reset to factory settings!</b></p>
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
                <a href="/cgi-bin/app.lua/settings/speaker.lp">Return to previous page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
