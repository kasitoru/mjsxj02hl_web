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
            local default_settings = fnc.app.default_settings()
            local current_settings = fnc.app.current_settings()
            -- Settings form and logic
            if fnc.string.is_empty(cgilua.POST.action_save) and fnc.string.is_empty(cgilua.POST.action_defaults) then
                %>
                <p class="lead mb-4"><b>Night vision settings</b></p>
                <form method="POST" id="settings_form" class="d-grid gap-2 justify-content-sm-center">
                    <div class="form-group text-start">
                        <label for="mode" class="form-label">Night mode:</label>
                        <select class="form-select" id="mode" name="mode">
                            <option value="0"<% if current_settings.night.mode == 0 then cgilua.print(" selected") end %>>Disabled</option>
                            <option value="1"<% if current_settings.night.mode == 1 then cgilua.print(" selected") end %>>Enabled</option>
                            <option value="2"<% if current_settings.night.mode == 2 then cgilua.print(" selected") end %>>Automatic</option>
                        </select>
                    </div>
                    <div class="form-group text-start">
                        <label for="gray" class="form-label">Grayscale:</label>
                        <select class="form-select" id="gray" name="gray">
                            <option value="0"<% if current_settings.night.gray == 0 then cgilua.print(" selected") end %>>Disabled</option>
                            <option value="1"<% if current_settings.night.gray == 1 then cgilua.print(" selected") end %>>Enabled</option>
                            <option value="2"<% if current_settings.night.gray == 2 then cgilua.print(" selected") end %>>Automatic</option>
                        </select>
                    </div>
                    <br>
                    <input type="submit" name="action_save" class="btn btn-primary btn-lg px-4 gap-3" value="Save">
                    <input type="submit" name="action_defaults" class="btn btn-outline-secondary btn-lg px-4" value="Defaults">
                </form>
                <%
            else
                if not fnc.string.is_empty(cgilua.POST.action_save) then
                    current_settings.night.mode = fnc.number.boundaries(lua.tonumber(cgilua.POST.mode or default_settings.night.mode), 0, 2)
                    current_settings.night.gray = fnc.number.boundaries(lua.tonumber(cgilua.POST.gray or default_settings.night.gray), 0, 2)
                    %>
                    <p class="lead mb-4"><b>Night vision settings saved successfully!</b></p>
                    <%
                elseif not fnc.string.is_empty(cgilua.POST.action_defaults) then
                    current_settings.night = default_settings.night
                    %>
                    <p class="lead mb-4"><b>Night vision successfully reset to factory settings!</b></p>
                    <%
                else
                    cgilua.redirect("/")
                    return
                end
                lip.save(fnc.app.settings_file(), current_settings);
                if not fnc.app.restart() then
                    %>
                    <p class="lead mb-4 text-danger">Error restarting the MJSXJ02HL application!<br>Please <a href="/cgi-bin/app.lua/system/reboot.lp">reboot</a> your device manually.</p>
                    <%
                end
                %>
                <a href="/cgi-bin/app.lua/settings/night_vision.lp">Return to previous page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
