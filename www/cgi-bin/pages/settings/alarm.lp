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
                <p class="lead mb-4"><b>Alarm settings</b></p>
                <form method="POST" id="settings_form" class="d-grid gap-2 justify-content-sm-center">
                    <p class="lead mb-0">Motion</p>
                    <div class="form-group text-start">
                        <label for="motion_sens" class="form-label">Sensitivity (1-255):</label>
                        <input type="text" class="form-control" id="motion_sens" name="motion_sens" placeholder="<%= default_settings.alarm.motion_sens %>" value="<%= current_settings.alarm.motion_sens %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="motion_timeout" class="form-label">Timeout (in seconds):</label>
                        <input type="text" class="form-control" id="motion_timeout" name="motion_timeout" placeholder="<%= default_settings.alarm.motion_timeout %>" value="<%= current_settings.alarm.motion_timeout %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="motion_detect_exec" class="form-label">Execute the command when detected:</label>
                        <input type="text" class="form-control" id="motion_detect_exec" name="motion_detect_exec" placeholder="<%= default_settings.alarm.motion_detect_exec %>" value="<%= current_settings.alarm.motion_detect_exec %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="motion_lost_exec" class="form-label">Execute the command when lost:</label>
                        <input type="text" class="form-control" id="motion_lost_exec" name="motion_lost_exec" placeholder="<%= default_settings.alarm.motion_lost_exec %>" value="<%= current_settings.alarm.motion_lost_exec %>">
                    </div>
                    <br>
                    <p class="lead mb-0">Humanoid</p>
                    <div class="form-group text-start">
                        <label for="humanoid_sens" class="form-label">Sensitivity (1-255):</label>
                        <input type="text" class="form-control" id="humanoid_sens" name="humanoid_sens" placeholder="<%= default_settings.alarm.humanoid_sens %>" value="<%= current_settings.alarm.humanoid_sens %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="humanoid_timeout" class="form-label">Timeout (in seconds):</label>
                        <input type="text" class="form-control" id="humanoid_timeout" name="humanoid_timeout" placeholder="<%= default_settings.alarm.humanoid_timeout %>" value="<%= current_settings.alarm.humanoid_timeout %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="humanoid_detect_exec" class="form-label">Execute the command when detected:</label>
                        <input type="text" class="form-control" id="humanoid_detect_exec" name="humanoid_detect_exec" placeholder="<%= default_settings.alarm.humanoid_detect_exec %>" value="<%= current_settings.alarm.humanoid_detect_exec %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="humanoid_lost_exec" class="form-label">Execute the command when lost:</label>
                        <input type="text" class="form-control" id="humanoid_lost_exec" name="humanoid_lost_exec" placeholder="<%= default_settings.alarm.humanoid_lost_exec %>" value="<%= current_settings.alarm.humanoid_lost_exec %>">
                    </div>
                    <br>
                    <input type="submit" name="action_save" class="btn btn-primary btn-lg px-4 gap-3" value="Save">
                    <input type="submit" name="action_defaults" class="btn btn-outline-secondary btn-lg px-4" value="Defaults">
                </form>
                <%
            else
                if not fnc.string.is_empty(cgilua.POST.action_save) then
                    -- Motion
                    current_settings.alarm.motion_sens = fnc.number.boundaries(lua.tonumber(cgilua.POST.motion_sens or default_settings.alarm.motion_sens), 1, 255)
                    current_settings.alarm.motion_timeout = lua.tonumber(cgilua.POST.motion_timeout or default_settings.alarm.motion_timeout)
                    current_settings.alarm.motion_detect_exec = (cgilua.POST.motion_detect_exec or default_settings.alarm.motion_detect_exec)
                    current_settings.alarm.motion_lost_exec = (cgilua.POST.motion_lost_exec or default_settings.alarm.motion_lost_exec)
                    -- Humanoid
                    current_settings.alarm.humanoid_sens = fnc.number.boundaries(lua.tonumber(cgilua.POST.humanoid_sens or default_settings.alarm.humanoid_sens), 1, 255)
                    current_settings.alarm.humanoid_timeout = lua.tonumber(cgilua.POST.humanoid_timeout or default_settings.alarm.humanoid_timeout)
                    current_settings.alarm.humanoid_detect_exec = (cgilua.POST.humanoid_detect_exec or default_settings.alarm.humanoid_detect_exec)
                    current_settings.alarm.humanoid_lost_exec = (cgilua.POST.humanoid_lost_exec or default_settings.alarm.humanoid_lost_exec)
                    %>
                    <p class="lead mb-4"><b>Alarm settings saved successfully!</b></p>
                    <%
                elseif not fnc.string.is_empty(cgilua.POST.action_defaults) then
                    current_settings.alarm = default_settings.alarm
                    %>
                    <p class="lead mb-4"><b>Alarm successfully reset to factory settings!</b></p>
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
                <a href="/cgi-bin/app.lua/settings/alarm.lp">Return to previous page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
