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
                <p class="lead mb-4"><b>Video settings</b></p>
                <form method="POST" id="settings_form" class="d-grid gap-2 justify-content-sm-center">
                    <div class="form-group text-start">
                        <label for="gop" class="form-label">Group of pictures (GOP) every N*FPS (20):</label>
                        <input type="text" class="form-control" id="gop" name="gop" placeholder="<%= default_settings.video.gop %>" value="<%= current_settings.video.gop %>">
                    </div>
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="flip" name="flip"<% if current_settings.video.flip then cgilua.print(" checked") end %>>
                        <label for="flip" class="form-check-label">Flip</label>
                    </div>
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="mirror" name="mirror"<% if current_settings.video.mirror then cgilua.print(" checked") end %>>
                        <label for="mirror" class="form-check-label">Mirror</label>
                    </div>
                    <p class="lead mb-0">Primary channel</p>
                    <div class="form-group text-start">
                        <label for="primary_type" class="form-label">Video compression standard:</label>
                        <select class="form-select" id="primary_type" name="primary_type">
                            <option value="1"<% if current_settings.video.primary_type == 1 then cgilua.print(" selected") end %>>H.264 (AVC)</option>
                            <option value="2"<% if current_settings.video.primary_type == 2 then cgilua.print(" selected") end %>>H.265 (HEVC)</option>
                        </select>
                    </div>
                    <div class="form-group text-start">
                        <label for="primary_bitrate" class="form-label">Bitrate (kbps):</label>
                        <input type="text" class="form-control" id="primary_bitrate" name="primary_bitrate" placeholder="<%= default_settings.video.primary_bitrate %>" value="<%= current_settings.video.primary_bitrate %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="primary_rcmode" class="form-label">Rate control mode:</label>
                        <select class="form-select" id="primary_rcmode" name="primary_rcmode">
                            <option value="0"<% if current_settings.video.primary_rcmode == 0 then cgilua.print(" selected") end %>>Constant bitrate</option>
                            <option value="1"<% if current_settings.video.primary_rcmode == 1 then cgilua.print(" selected") end %>>Constant quality</option>
                            <option value="2"<% if current_settings.video.primary_rcmode == 2 then cgilua.print(" selected") end %>>Variable bitrate</option>
                        </select>
                    </div>
                    <p class="lead mb-0">Secondary channel</p>
                    <div class="form-group text-start">
                        <label for="secondary_type" class="form-label">Video compression standard:</label>
                        <select class="form-select" id="secondary_type" name="secondary_type">
                            <option value="1"<% if current_settings.video.secondary_type == 1 then cgilua.print(" selected") end %>>H.264 (AVC)</option>
                            <option value="2"<% if current_settings.video.secondary_type == 2 then cgilua.print(" selected") end %>>H.265 (HEVC)</option>
                        </select>
                    </div>
                    <div class="form-group text-start">
                        <label for="secondary_bitrate" class="form-label">Bitrate (kbps):</label>
                        <input type="text" class="form-control" id="secondary_bitrate" name="secondary_bitrate" placeholder="<%= default_settings.video.secondary_bitrate %>" value="<%= current_settings.video.secondary_bitrate %>">
                    </div>
                    <div class="form-group text-start">
                        <label for="secondary_rcmode" class="form-label">Rate control mode:</label>
                        <select class="form-select" id="secondary_rcmode" name="secondary_rcmode">
                            <option value="0"<% if current_settings.video.secondary_rcmode == 0 then cgilua.print(" selected") end %>>Constant bitrate</option>
                            <option value="1"<% if current_settings.video.secondary_rcmode == 1 then cgilua.print(" selected") end %>>Constant quality</option>
                            <option value="2"<% if current_settings.video.secondary_rcmode == 2 then cgilua.print(" selected") end %>>Variable bitrate</option>
                        </select>
                    </div>
                    <br>
                    <input type="submit" name="action_save" class="btn btn-primary btn-lg px-4 gap-3" value="Save">
                    <input type="submit" name="action_defaults" class="btn btn-outline-secondary btn-lg px-4" value="Defaults">
                </form>
                <%
            else
                if not fnc.string.is_empty(cgilua.POST.action_save) then
                    current_settings.video.gop = fnc.number.boundaries(lua.tonumber(cgilua.POST.gop or default_settings.video.gop), 1, 60)
                    if cgilua.POST.flip then current_settings.video.flip = true else current_settings.video.flip = false end
                    if cgilua.POST.mirror then current_settings.video.mirror = true else current_settings.video.mirror = false end
                    current_settings.video.primary_type = fnc.number.boundaries(lua.tonumber(cgilua.POST.primary_type or default_settings.video.primary_type), 1, 2)
                    current_settings.video.primary_bitrate = fnc.number.boundaries(lua.tonumber(cgilua.POST.primary_bitrate or default_settings.video.primary_bitrate), 2, 61480)
                    current_settings.video.primary_rcmode = fnc.number.boundaries(lua.tonumber(cgilua.POST.primary_rcmode or default_settings.video.primary_rcmode), 0, 2)
                    current_settings.video.secondary_type = fnc.number.boundaries(lua.tonumber(cgilua.POST.secondary_type or default_settings.video.secondary_type), 1, 2)
                    current_settings.video.secondary_bitrate = fnc.number.boundaries(lua.tonumber(cgilua.POST.secondary_bitrate or default_settings.video.secondary_bitrate), 2, 61480)
                    current_settings.video.secondary_rcmode = fnc.number.boundaries(lua.tonumber(cgilua.POST.secondary_rcmode or default_settings.video.secondary_rcmode), 0, 2)
                    %>
                    <p class="lead mb-4"><b>Video settings saved successfully!</b></p>
                    <%
                elseif not fnc.string.is_empty(cgilua.POST.action_defaults) then
                    current_settings.video = default_settings.video
                    %>
                    <p class="lead mb-4"><b>Video successfully reset to factory settings!</b></p>
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
                <a href="/cgi-bin/app.lua/settings/video.lp">Return to previous page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
