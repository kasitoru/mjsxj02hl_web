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
            -- Get current and default time zone
            local timezone_file = "/configs/TZ"
            local default_timezone = "UTC-3"
            local current_timezone = fnc.file.get_contents(timezone_file)
            current_timezone = fnc.string.trim(current_timezone, "\n")
            if fnc.string.is_empty(current_timezone) then
                current_timezone = default_timezone
            end
            -- Settings form and logic
            if fnc.string.is_empty(cgilua.POST.action_save) and fnc.string.is_empty(cgilua.POST.action_defaults) then
                %>
                <p class="lead mb-4"><b>General settings</b></p>
                <form method="POST" id="settings_form" class="d-grid gap-2 justify-content-sm-center">
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="led" name="led"<% if current_settings.general.led then cgilua.print(" checked") end %>>
                        <label for="led" class="form-check-label">Enable LED indicator</label>
                    </div>
                    <div class="form-group text-start">
                        <label for="timezone" class="form-label">Time zone:</label>
                        <select class="form-select" id="timezone" name="timezone">
                            <option value="UTC+12:00"<% if current_timezone == "UTC+12:00" then cgilua.print(" selected") end %>>UTC-12:00</option>
                            <option value="UTC+11:00"<% if current_timezone == "UTC+11:00" then cgilua.print(" selected") end %>>UTC-11:00</option>
                            <option value="UTC+10:00"<% if current_timezone == "UTC+10:00" then cgilua.print(" selected") end %>>UTC-10:00</option>
                            <option value="UTC+9:30"<% if current_timezone == "UTC+9:30" then cgilua.print(" selected") end %>>UTC-9:30</option>
                            <option value="UTC+9:00"<% if current_timezone == "UTC+9:00" then cgilua.print(" selected") end %>>UTC-9:00</option>
                            <option value="UTC+8:00"<% if current_timezone == "UTC+8:00" then cgilua.print(" selected") end %>>UTC-8:00</option>
                            <option value="UTC+7:00"<% if current_timezone == "UTC+7:00" then cgilua.print(" selected") end %>>UTC-7:00</option>
                            <option value="UTC+6:00"<% if current_timezone == "UTC+6:00" then cgilua.print(" selected") end %>>UTC-6:00</option>
                            <option value="UTC+5:00"<% if current_timezone == "UTC+5:00" then cgilua.print(" selected") end %>>UTC-5:00</option>
                            <option value="UTC+4:30"<% if current_timezone == "UTC+4:30" then cgilua.print(" selected") end %>>UTC-4:30</option>
                            <option value="UTC+4:00"<% if current_timezone == "UTC+4:00" then cgilua.print(" selected") end %>>UTC-4:00</option>
                            <option value="UTC+3:30"<% if current_timezone == "UTC+3:30" then cgilua.print(" selected") end %>>UTC-3:30</option>
                            <option value="UTC+3:00"<% if current_timezone == "UTC+3:00" then cgilua.print(" selected") end %>>UTC-3:00</option>
                            <option value="UTC+2:00"<% if current_timezone == "UTC+2:00" then cgilua.print(" selected") end %>>UTC-2:00</option>
                            <option value="UTC+1:00"<% if current_timezone == "UTC+1:00" then cgilua.print(" selected") end %>>UTC-1:00</option>
                            <option value="UTC"<% if current_timezone == "UTC" then cgilua.print(" selected") end %>>UTC</option>
                            <option value="UTC-1:00"<% if current_timezone == "UTC-1:00" then cgilua.print(" selected") end %>>UTC+1:00</option>
                            <option value="UTC-2:00"<% if current_timezone == "UTC-2:00" then cgilua.print(" selected") end %>>UTC+2:00</option>
                            <option value="UTC-3:00"<% if current_timezone == "UTC-3:00" then cgilua.print(" selected") end %>>UTC+3:00</option>
                            <option value="UTC-3:30"<% if current_timezone == "UTC-3:30" then cgilua.print(" selected") end %>>UTC+3:30</option>
                            <option value="UTC-4:00"<% if current_timezone == "UTC-4:00" then cgilua.print(" selected") end %>>UTC+4:00</option>
                            <option value="UTC-4:30"<% if current_timezone == "UTC-4:30" then cgilua.print(" selected") end %>>UTC+4:30</option>
                            <option value="UTC-5:00"<% if current_timezone == "UTC-5:00" then cgilua.print(" selected") end %>>UTC+5:00</option>
                            <option value="UTC-5:30"<% if current_timezone == "UTC-5:30" then cgilua.print(" selected") end %>>UTC+5:30</option>
                            <option value="UTC-5:45"<% if current_timezone == "UTC-5:45" then cgilua.print(" selected") end %>>UTC+5:45</option>
                            <option value="UTC-6:00"<% if current_timezone == "UTC-6:00" then cgilua.print(" selected") end %>>UTC+6:00</option>
                            <option value="UTC-6:30"<% if current_timezone == "UTC-6:30" then cgilua.print(" selected") end %>>UTC+6:30</option>
                            <option value="UTC-7:00"<% if current_timezone == "UTC-7:00" then cgilua.print(" selected") end %>>UTC+7:00</option>
                            <option value="UTC-8:00"<% if current_timezone == "UTC-8:00" then cgilua.print(" selected") end %>>UTC+8:00</option>
                            <option value="UTC-9:00"<% if current_timezone == "UTC-9:00" then cgilua.print(" selected") end %>>UTC+9:00</option>
                            <option value="UTC-9:30"<% if current_timezone == "UTC-9:30" then cgilua.print(" selected") end %>>UTC+9:30</option>
                            <option value="UTC-10:00"<% if current_timezone == "UTC-10:00" then cgilua.print(" selected") end %>>UTC+10:00</option>
                            <option value="UTC-10:30"<% if current_timezone == "UTC-10:30" then cgilua.print(" selected") end %>>UTC+10:30</option>
                            <option value="UTC-11:00"<% if current_timezone == "UTC-11:00" then cgilua.print(" selected") end %>>UTC+11:00</option>
                            <option value="UTC-12:00"<% if current_timezone == "UTC-12:00" then cgilua.print(" selected") end %>>UTC+12:00</option>
                            <option value="UTC-12:45"<% if current_timezone == "UTC-12:45" then cgilua.print(" selected") end %>>UTC+12:45</option>
                        </select>
                    </div>
                    <br>
                    <input type="submit" name="action_save" class="btn btn-primary btn-lg px-4 gap-3" value="Save">
                    <input type="submit" name="action_defaults" class="btn btn-outline-secondary btn-lg px-4" value="Defaults">
                </form>
                <%
            else
                if not fnc.string.is_empty(cgilua.POST.action_save) then
                    if cgilua.POST.led then current_settings.general.led = true else current_settings.general.led = false end
                    current_timezone = (cgilua.POST.timezone or default_timezone)
                    %>
                    <p class="lead mb-4"><b>General settings saved successfully!</b></p>
                    <%
                elseif not fnc.string.is_empty(cgilua.POST.action_defaults) then
                    current_settings.general = default_settings.general
                    current_timezone = default_timezone
                    %>
                    <p class="lead mb-4"><b>General successfully reset to factory settings!</b></p>
                    <%
                else
                    cgilua.redirect("/")
                    return
                end
                lip.save(config_file, current_settings);
                fnc.file.put_contents(timezone_file, current_timezone .. "\n");
                if not fnc.app.restart() then
                    %>
                    <p class="lead mb-4 text-danger">Error restarting the MJSXJ02HL application!<br>Please <a href="/cgi-bin/app.lua/system/reboot.lp">reboot</a> your device manually.</p>
                    <%
                end
                %>
                <a href="/cgi-bin/app.lua/settings/general.lp">Return to previous page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
