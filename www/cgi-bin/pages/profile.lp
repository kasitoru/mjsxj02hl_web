<%
os = required.os
fnc = required.fnc
%>
<main class="container">
    <div class="bg-light p-5 rounded">
        <div class="text-center">
            <%
            -- Settings form and logic
            if fnc.string.is_empty(cgilua.POST.action_save) then
                %>
                <p class="lead mb-4"><b>Profile</b></p>
                <form method="POST" id="settings_form" class="d-grid gap-2 justify-content-sm-center">
                    <div class="form-group text-start">
                        <label for="username" class="form-label">Username:</label>
                        <input type="text" class="form-control" id="username" name="username" value="<%= cgilua.authentication.username() %>" readonly="readonly">
                    </div>
                    <div class="form-group text-start">
                        <label for="current_passwd" class="form-label">Current password:</label>
                        <input type="password" class="form-control" id="current_passwd" name="current_passwd">
                    </div>
                    <div class="form-group text-start">
                        <label for="new_passwd" class="form-label">New password:</label>
                        <input type="password" class="form-control" id="new_passwd" name="new_passwd">
                    </div>
                    <div class="form-group text-start">
                        <label for="confirm_passwd" class="form-label">Confirm password:</label>
                        <input type="password" class="form-control" id="confirm_passwd" name="confirm_passwd">
                    </div>
                    <br>
                    <input type="submit" name="action_save" class="btn btn-primary btn-lg px-4 gap-3" value="Save">
                </form>
                <%
            else
                if not fnc.string.is_empty(cgilua.POST.username) then
                    if not fnc.string.is_empty(cgilua.POST.current_passwd) then
                        local passwd_check, passwd_error = cgilua.authentication.check(cgilua.POST.username, cgilua.POST.current_passwd)
                        if passwd_check then
                            if not fnc.string.is_empty(cgilua.POST.new_passwd) then
                                if not fnc.string.is_empty(cgilua.POST.confirm_passwd) then
                                    if cgilua.POST.new_passwd == cgilua.POST.confirm_passwd then
                                        if os.execute("echo -e \"" .. cgilua.POST.new_passwd .. "\n" .. cgilua.POST.confirm_passwd .. "\" | passwd -a des " .. cgilua.POST.username) then
                                            %>
                                            <p class="lead mb-4"><b>Password changed successfully!</b></p>
                                            <%
                                        else
                                            %>
                                            <p class="lead mb-4 text-danger">Password change error!</p>
                                            <%
                                        end
                                    else
                                        %>
                                        <p class="lead mb-4 text-danger">The entered passwords do not match!</p>
                                        <%
                                    end
                                else
                                    %>
                                    <p class="lead mb-4 text-danger">Please, confirm a new password!</p>
                                    <%
                                end
                            else
                                %>
                                <p class="lead mb-4 text-danger">Please, enter a new password!</p>
                                <%
                            end
                        else
                            %>
                            <p class="lead mb-4 text-danger">Current password error: <%= passwd_error %></p>
                            <%
                        end
                    else
                        %>
                        <p class="lead mb-4 text-danger">Please, enter your current password!</p>
                        <%
                    end
                else
                    %>
                    <p class="lead mb-4 text-danger">Please, enter your username!</p>
                    <%
                end
                %>
                <a href="/cgi-bin/app.lua/profile.lp">Return to previous page</a>
                <%
            end
            %>
        </div>
    </div>
</main>
