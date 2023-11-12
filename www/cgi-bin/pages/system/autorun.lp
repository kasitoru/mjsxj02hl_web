<%
lua = required.lua
fnc = required.fnc
%>
<main class="container">
    <div class="bg-light p-5 rounded">
        <div class="text-center">
            <%
            -- Get current and default autorun
            local autorun_file = "/configs/run.sh"
            local default_autorun = "#!/bin/sh\n\n# Launching the watchdog\nwatchdog.sh &"
            local current_autorun = fnc.file.get_contents(autorun_file)
            current_autorun = fnc.string.trim(current_autorun, "\n")
            if fnc.string.is_empty(current_autorun) then
                current_autorun = default_autorun
            end
            -- Settings form and logic
            if fnc.string.is_empty(cgilua.POST.action_save) and fnc.string.is_empty(cgilua.POST.action_defaults) then
                %>
                <p class="lead mb-4"><b>Autorun</b></p>
                <form method="POST" id="settings_form" class="d-grid gap-2 justify-content-sm-center">
                    <div class="form-group text-start">
                        <label for="autorun" class="form-label"><%= autorun_file %>:</label>
                        <textarea class="form-control" id="autorun" name="autorun"><%= current_autorun %></textarea>
                    </div>
                    <br>
                    <input type="submit" name="action_save" class="btn btn-primary btn-lg px-4 gap-3" value="Save">
                    <input type="submit" name="action_defaults" class="btn btn-outline-secondary btn-lg px-4" value="Defaults">
                </form>
                <%
            else
                if not fnc.string.is_empty(cgilua.POST.action_save) then
                    current_autorun = (cgilua.POST.autorun or default_autorun)
                    %>
                    <p class="lead mb-4"><b>Autorun settings saved successfully!</b></p>
                    <%
                elseif not fnc.string.is_empty(cgilua.POST.action_defaults) then
                    current_autorun = default_autorun
                    %>
                    <p class="lead mb-4"><b>Autorun successfully reset to factory settings!</b></p>
                    <%
                else
                    cgilua.redirect("/")
                    return
                end
                fnc.file.put_contents(autorun_file, current_autorun .. "\n");
                %>
                <a href="/cgi-bin/app.lua/system/autorun.lp">Return to previous page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
