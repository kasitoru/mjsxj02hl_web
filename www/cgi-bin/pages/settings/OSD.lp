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
                <p class="lead mb-4"><b>OSD settings</b></p>
                <form method="POST" id="settings_form" class="d-grid gap-2 justify-content-sm-center">
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="enable" name="enable"<% if current_settings.osd.enable then cgilua.print(" checked") end %>>
                        <label for="enable" class="form-check-label">Enable On-Screen Display</label>
                    </div>
                    <p class="lead mb-0">OEM logo (MI)</p>
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="oemlogo" name="oemlogo"<% if current_settings.osd.oemlogo then cgilua.print(" checked") end %>>
                        <label for="oemlogo" class="form-check-label">Show</label>
                    </div>
                    <div class="form-group text-start">
                        <label for="oemlogo_x" class="form-label">Horizontal position (px):</label>
                        <input type="text" class="form-control" id="oemlogo_x" name="oemlogo_x" placeholder="<%= default_settings.osd.oemlogo_x %>" value="<%= current_settings.osd.oemlogo_x %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="oemlogo_y" class="form-label">Vertical position (px):</label>
                        <input type="text" class="form-control" id="oemlogo_y" name="oemlogo_y" placeholder="<%= default_settings.osd.oemlogo_y %>" value="<%= current_settings.osd.oemlogo_y %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="oemlogo_size" class="form-label">Size:</label>
                        <select class="form-select" id="oemlogo_size" name="oemlogo_size">
                            <option value="-3"<% if current_settings.osd.oemlogo_size == -3 then cgilua.print(" selected") end %>>Shallow (-3)</option>
                            <option value="-2"<% if current_settings.osd.oemlogo_size == -2 then cgilua.print(" selected") end %>>Little (-2)</option>
                            <option value="-1"<% if current_settings.osd.oemlogo_size == -1 then cgilua.print(" selected") end %>>Small (-1)</option>
                            <option value="0"<% if current_settings.osd.oemlogo_size == 0 then cgilua.print(" selected") end %>>Normal (0)</option>
                            <option value="1"<% if current_settings.osd.oemlogo_size == 1 then cgilua.print(" selected") end %>>Medium (+1)</option>
                            <option value="2"<% if current_settings.osd.oemlogo_size == 2 then cgilua.print(" selected") end %>>Big (+2)</option>
                            <option value="3"<% if current_settings.osd.oemlogo_size == 3 then cgilua.print(" selected") end %>>Huge (+3)</option>
                        </select>
                    </div>
                    <p class="lead mb-0">Date and Time</p>
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="datetime" name="datetime"<% if current_settings.osd.datetime then cgilua.print(" checked") end %>>
                        <label for="datetime" class="form-check-label">Show</label>
                    </div>
                    <div class="form-group text-start">
                        <label for="datetime_x" class="form-label">Horizontal position (px):</label>
                        <input type="text" class="form-control" id="datetime_x" name="datetime_x" placeholder="<%= default_settings.osd.datetime_x %>" value="<%= current_settings.osd.datetime_x %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="datetime_y" class="form-label">Vertical position (px):</label>
                        <input type="text" class="form-control" id="datetime_y" name="datetime_y" placeholder="<%= default_settings.osd.datetime_y %>" value="<%= current_settings.osd.datetime_y %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="datetime_size" class="form-label">Size:</label>
                        <select class="form-select" id="datetime_size" name="datetime_size">
                            <option value="-3"<% if current_settings.osd.datetime_size == -3 then cgilua.print(" selected") end %>>Shallow (-3)</option>
                            <option value="-2"<% if current_settings.osd.datetime_size == -2 then cgilua.print(" selected") end %>>Little (-2)</option>
                            <option value="-1"<% if current_settings.osd.datetime_size == -1 then cgilua.print(" selected") end %>>Small (-1)</option>
                            <option value="0"<% if current_settings.osd.datetime_size == 0 then cgilua.print(" selected") end %>>Normal (0)</option>
                            <option value="1"<% if current_settings.osd.datetime_size == 1 then cgilua.print(" selected") end %>>Medium (+1)</option>
                            <option value="2"<% if current_settings.osd.datetime_size == 2 then cgilua.print(" selected") end %>>Big (+2)</option>
                            <option value="3"<% if current_settings.osd.datetime_size == 3 then cgilua.print(" selected") end %>>Huge (+3)</option>
                        </select>
                    </div>
                    <p class="lead mb-0">Selecting objects</p>
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="motion" name="motion"<% if current_settings.osd.motion then cgilua.print(" checked") end %>>
                        <label for="motion" class="form-check-label">Motion</label>
                    </div>
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="humanoid" name="humanoid"<% if current_settings.osd.humanoid then cgilua.print(" checked") end %>>
                        <label for="humanoid" class="form-check-label">Humanoid</label>
                    </div>
                    <br>
                    <input type="submit" name="action_save" class="btn btn-primary btn-lg px-4 gap-3" value="Save">
                    <input type="submit" name="action_defaults" class="btn btn-outline-secondary btn-lg px-4" value="Defaults">
                </form>
                <%
            else
                if not fnc.string.is_empty(cgilua.POST.action_save) then
                    if cgilua.POST.enable then current_settings.osd.enable = true else current_settings.osd.enable = false end
                    if cgilua.POST.oemlogo then current_settings.osd.oemlogo = true else current_settings.osd.oemlogo = false end
                    current_settings.osd.oemlogo_x = fnc.number.boundaries(lua.tonumber(cgilua.POST.oemlogo_x or default_settings.osd.oemlogo_x), 0, 1920)
                    current_settings.osd.oemlogo_y = fnc.number.boundaries(lua.tonumber(cgilua.POST.oemlogo_y or default_settings.osd.oemlogo_y), 0, 1080)
                    current_settings.osd.oemlogo_size = fnc.number.boundaries(lua.tonumber(cgilua.POST.oemlogo_size or default_settings.osd.oemlogo_size), -3, 3)
                    if cgilua.POST.datetime then current_settings.osd.datetime = true else current_settings.osd.datetime = false end
                    current_settings.osd.datetime_x = fnc.number.boundaries(lua.tonumber(cgilua.POST.datetime_x or default_settings.osd.datetime_x), 0, 1920)
                    current_settings.osd.datetime_y = fnc.number.boundaries(lua.tonumber(cgilua.POST.datetime_y or default_settings.osd.datetime_y), 0, 1080)
                    current_settings.osd.datetime_size = fnc.number.boundaries(lua.tonumber(cgilua.POST.datetime_size or default_settings.osd.datetime_size), -3, 3)
                    if cgilua.POST.motion then current_settings.osd.motion = true else current_settings.osd.motion = false end
                    if cgilua.POST.humanoid then current_settings.osd.humanoid = true else current_settings.osd.humanoid = false end
                    %>
                    <p class="lead mb-4"><b>OSD settings saved successfully!</b></p>
                    <%
                elseif not fnc.string.is_empty(cgilua.POST.action_defaults) then
                    current_settings.osd = default_settings.osd
                    %>
                    <p class="lead mb-4"><b>OSD successfully reset to factory settings!</b></p>
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
                <a href="/cgi-bin/app.lua/settings/OSD.lp">Return to previous page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
