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
                <p class="lead mb-4"><b>Video settings</b></p>
                <form method="POST" id="settings_form" class="d-grid gap-2 justify-content-sm-center">
                    <div class="form-group text-start">
                        <label for="type" class="form-label">Video compression standard:</label>
                        <select class="form-select" id="type" name="type">
                            <option value="1"<% if current_settings.video.type == 1 then cgilua.print(" selected") end %>>H.264 (AVC)</option>
                            <option value="2"<% if current_settings.video.type == 2 then cgilua.print(" selected") end %>>H.265 (HEVC)</option>
                        </select>
                    </div>
                    <div class="form-group text-start">
                        <label for="fps" class="form-label">Frames per second:</label>
                        <input type="text" class="form-control" id="fps" name="fps" placeholder="<%= default_settings.video.fps %>" value="<%= current_settings.video.fps %>">
                    </div>
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="flip" name="flip"<% if current_settings.video.flip then cgilua.print(" checked") end %>>
                        <label for="flip" class="form-check-label">Flip</label>
                    </div>
                    <div class="form-group text-start">
                        <input type="checkbox" class="form-check-input" id="mirror" name="mirror"<% if current_settings.video.mirror then cgilua.print(" checked") end %>>
                        <label for="mirror" class="form-check-label">Mirror</label>
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
                    current_settings.video.type = lua.tonumber(cgilua.POST.type or default_settings.video.type)
                    if current_settings.video.type < 1 then current_settings.video.type = 1 end
                    if current_settings.video.type > 2 then current_settings.video.type = 2 end
                    if cgilua.POST.flip then current_settings.video.flip = true else current_settings.video.flip = false end
                    if cgilua.POST.mirror then current_settings.video.mirror = true else current_settings.video.mirror = false end
                    %>
                    <p class="lead mb-4"><b>Video settings saved successfully!</b></p>
                    <%
                elseif cgilua.POST.action == "action_defaults" then
                    current_settings.video = default_settings.video
                    %>
                    <p class="lead mb-4"><b>Video successfully reset to factory settings!</b></p>
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
                <a href="/cgi-bin/app.lua/settings/video.lp">Return to previous page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
