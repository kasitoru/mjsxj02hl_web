<%
-- Forbidding logged in user
if cgilua.authentication.username() then
    cgilua.redirect("/")
    return
end
%>
<style>
    html, body {
        height: 100%;
    }
    body {
        display: flex;
        align-items: center;
        padding-bottom: 100px;
        background-color: #f5f5f5;
    }
    .form-login {
        width: 100%;
        max-width: 330px;
        padding: 15px;
        margin: auto;
    }
    .form-login .form-floating:focus-within {
        z-index: 2;
    }
    .form-login input[type="text"] {
        margin-bottom: -1px;
        border-bottom-right-radius: 0;
        border-bottom-left-radius: 0;
    }
    .form-login input[type="password"] {
        margin-bottom: 10px;
        border-top-left-radius: 0;
        border-top-right-radius: 0;
    }
</style>
<main class="form-login text-center">
    <form method="POST">
        <h1 class="h3 mb-3 fw-normal">Authentification:</h1>
        <%
        if page_info.message ~= nil and page_info.message ~= "" then
            cgilua.print([[<div class="alert alert-danger" role="alert">]])
            cgilua.print(page_info.message)
            cgilua.print([[</div>]])
        end
        %>
        <div class="form-floating">
            <input type="text" class="form-control" id="floatingInput" name="username" placeholder="User" value="<%= username %>">
            <label for="floatingInput">User</label>
        </div>
        <div class="form-floating">
            <input type="password" class="form-control" id="floatingPassword" name="password" placeholder="Password">
            <label for="floatingPassword">Password</label>
        </div>
        <button class="w-100 btn btn-lg btn-primary" type="submit">Login</button>
    </form>
</main>
