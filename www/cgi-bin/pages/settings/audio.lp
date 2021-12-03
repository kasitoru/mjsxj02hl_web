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
                <p class="lead mb-4"><b>Audio settings</b></p>
                <form method="POST" id="settings_form" class="d-grid gap-2 justify-content-sm-center">
                    <div class="form-group text-start">
                        <label for="volume" class="form-label">Volume level (0-100):</label>
                        <input type="text" class="form-control" id="volume" name="volume" placeholder="<%= default_settings.audio.volume %>" value="<%= current_settings.audio.volume %>">
                    </div>
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="primary_enable" name="primary_enable"<% if current_settings.audio.primary_enable then cgilua.print(" checked") end %>>
                        <label for="primary_enable" class="form-check-label">Enable for primary channel</label>
                    </div>
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="secondary_enable" name="secondary_enable"<% if current_settings.audio.secondary_enable then cgilua.print(" checked") end %>>
                        <label for="secondary_enable" class="form-check-label">Enable for secondary channel</label>
                    </div>
                    <br>
                    <input type="submit" name="action_save" class="btn btn-primary btn-lg px-4 gap-3" value="Save">
                    <input type="submit" name="action_defaults" class="btn btn-outline-secondary btn-lg px-4" value="Defaults">
                </form>
                <%
            else
                if not fnc.string.is_empty(cgilua.POST.action_save) then
                    current_settings.audio.volume = fnc.number.boundaries(lua.tonumber(cgilua.POST.volume or default_settings.audio.volume), 0, 100)
                    if cgilua.POST.primary_enable then current_settings.audio.primary_enable = true else current_settings.audio.primary_enable = false end
                    if cgilua.POST.secondary_enable then current_settings.audio.secondary_enable = true else current_settings.audio.secondary_enable = false end
                    %>
                    <p class="lead mb-4"><b>Audio settings saved successfully!</b></p>
                    <%
                elseif not fnc.string.is_empty(cgilua.POST.action_defaults) then
                    current_settings.audio = default_settings.audio
                    %>
                    <p class="lead mb-4"><b>Audio successfully reset to factory settings!</b></p>
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
                <a href="/cgi-bin/app.lua/settings/audio.lp">Return to previous page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
