<%
os = required.os
fnc = required.fnc
%>
<main class="container">
    <div class="bg-light p-5 rounded">
        <div class="text-center">
            <%
            if fnc.string.is_empty(cgilua.POST.choice_yes) and fnc.string.is_empty(cgilua.POST.choice_no) then
                %>
                <p class="lead mb-4"><b>Do you want to reboot device?</b></p>
                <form method="POST" id="choice_form" class="d-grid gap-2 d-sm-flex justify-content-sm-center">
                    <input type="submit" name="choice_yes" class="btn btn-primary btn-lg px-4 gap-3" value="Yes">
                    <input type="submit" name="choice_no" class="btn btn-outline-secondary btn-lg px-4" value="No">
                </form>
                <%
            else
                if not fnc.string.is_empty(cgilua.POST.choice_yes) then
                    if os.execute("reboot") then
                        %>
                        <p class="lead mb-4"><b>The device is being rebooted, it may take some time.</b></p>
                        <p class="lead mb-4">Wait <span id="wait_timer">30</span> second(s)...</p>
                        <script type="text/javascript">
                            (function() {
                                document.addEventListener("DOMContentLoaded", function(event) {
                                    var timer_element = document.getElementById("wait_timer");
                                    var timer_value = timer_element.textContent || timer_element.innerText;
                                    let timer_id = setInterval(function() {
                                        timer_value--;
                                        timer_element.textContent = timer_value;
                                        if(timer_value < 1) {
                                            clearInterval(timer_id);
                                            window.location.replace("/");
                                        }
                                    }, 1000);
                                });
                            })();
                        </script>
                        <%
                    else
                        %>
                        <p class="lead mb-4 text-danger"><b>Device reboot error!</b></p>
                        <%
                    end
                    %>
                    <a href="/" id="return_main">Return to main page</a>
                    <%
                else
                    cgilua.redirect("/")
                    return
                end
            end
            %>
        </div>
    </div>
</main>
