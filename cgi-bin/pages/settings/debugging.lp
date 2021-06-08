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
            if fnc.string.is_empty(cgilua.POST.action) then
                %>
                <p class="lead mb-4"><b>Debugging settings</b></p>
                <form method="POST" id="settings_form" class="d-grid gap-2 justify-content-sm-center">
                    <div class="form-group text-start">
                        <label for="level" class="form-label">Log level:</label>
                        <select class="form-select" id="level" name="level">
                            <option value="0"<% if current_settings.logger.level == 0 then cgilua.print(" selected") end %>>Disabled</option>
                            <option value="1"<% if current_settings.logger.level == 1 then cgilua.print(" selected") end %>>Errors</option>
                            <option value="2"<% if current_settings.logger.level == 2 then cgilua.print(" selected") end %>>Warnings</option>
                            <option value="3"<% if current_settings.logger.level == 3 then cgilua.print(" selected") end %>>Information</option>
                            <option value="4"<% if current_settings.logger.level == 4 then cgilua.print(" selected") end %>>Debug</option>
                        </select>
                    </div>
                    <div class="form-group text-start">
                        <label for="file" class="form-label">Write log to file (empty for disable):</label>
                        <input type="text" class="form-control" id="file" name="file" placeholder="<%= default_settings.logger.file %>" value="<%= current_settings.logger.file %>">
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
                    current_settings.logger.level = lua.tonumber(cgilua.POST.level or default_settings.logger.level)
                    if current_settings.logger.level < 0 then current_settings.logger.level = 0 end
                    if current_settings.logger.level > 4 then current_settings.logger.level = 4 end
                    current_settings.logger.file  = (cgilua.POST.file or default_settings.logger.file)
                    %>
                    <p class="lead mb-4"><b>Debugging settings saved successfully!</b></p>
                    <%
                elseif cgilua.POST.action == "action_defaults" then
                    current_settings.logger = default_settings.logger
                    %>
                    <p class="lead mb-4"><b>Debugging successfully reset to factory settings!</b></p>
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
                <a href="/cgi-bin/app.lua/settings/debugging.lp">Return to previous page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
