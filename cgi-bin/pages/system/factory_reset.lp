<%
os = required.os
fnc = required.fnc
%>
<main class="container">
    <div class="bg-light p-5 rounded">
        <div class="text-center">
            <%
            if fnc.string.is_empty(cgilua.POST.choice) then
                %>
                <p class="lead mb-4"><b>Do you want to reset your device to factory settings?</b></p>
                <form method="POST" id="choice_form" class="d-grid gap-2 d-sm-flex justify-content-sm-center">
                    <input type="hidden" id="choice_value" name="choice" value="">
                    <input type="button" id="choice_yes" class="btn btn-danger btn-lg px-4 gap-3" value="Yes">
                    <input type="button" id="choice_no" class="btn btn-outline-secondary btn-lg px-4" value="No">
                </form>
                <script type="text/javascript">
                    (function($) {
                        $(document).ready(function() {
                            var choice_form = $("form#choice_form")
                            $(choice_form).find("input[type=button]").filter("#choice_yes,#choice_no").on("click", function(e) {
                                $(choice_form).find("input#choice_value").val(e.target.id);
                                choice_form.submit();
                            });
                        });
                    })(jQuery); 
                </script>
                <%
            else
                if cgilua.POST.choice == "choice_yes" then
                    if os.execute("mjsxj02hl --factory-reset") then
                        %>
                        <p class="lead mb-4"><b>Factory reset is successful!<br>The device is being rebooted, it may take some time.</b></p>
                        <p class="lead mb-4">Wait <span id="wait_timer">30</span> second(s)...</p>
                        <script type="text/javascript">
                            (function($) {
                                $(document).ready(function() {
                                    var timer_value = $("#wait_timer").text();
                                    let timer_id = setInterval(function() {
                                        timer_value--;
                                        $("#wait_timer").text(timer_value);
                                        if(timer_value < 1) {
                                            clearInterval(timer_id);
                                            document.getElementById("return_main").click();
                                        }
                                    }, 1000);
                                });
                            })(jQuery); 
                        </script>
                        <%
                    else
                        %>
                        <p class="lead mb-4"><b>Factory reset error!</b></p>
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
