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
                        });
                    })(jQuery); 
                </script>
                <%
            else
                if cgilua.POST.action == "action_save" then
                    current_settings.night.mode = lua.tonumber(cgilua.POST.mode or default_settings.night.mode)
                    if current_settings.night.mode < 0 then current_settings.night.mode = 0 end
                    if current_settings.night.mode > 2 then current_settings.night.mode = 2 end
                    current_settings.night.gray = lua.tonumber(cgilua.POST.gray or default_settings.night.gray)
                    if current_settings.night.gray < 0 then current_settings.night.gray = 0 end
                    if current_settings.night.gray > 2 then current_settings.night.gray = 2 end
                    %>
                    <p class="lead mb-4"><b>Night vision settings saved successfully!</b></p>
                    <%
                elseif cgilua.POST.action == "action_defaults" then
                    current_settings.night = default_settings.night
                    %>
                    <p class="lead mb-4"><b>Night vision successfully reset to factory settings!</b></p>
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
                <a href="/cgi-bin/app.lua/settings/night_vision.lp">Return to previous page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
