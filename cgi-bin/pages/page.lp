<%
lfs = required.lfs
fnc = required.fnc

-- Add item to navbar
function navbar_add_item(name, url, active, top)
    local class = ""
    if active then class = "active" end
    if top then -- Top level
        cgilua.print([[<li class="nav-item">]])
        cgilua.print([[<a class="nav-link ]] .. class .. [[" aria-current="page" href="]] .. url .. [[">]])
    else -- Sub level
        cgilua.print([[<li class="]] .. class .. [[">]])
        cgilua.print([[<a class="dropdown-item" href="]] .. url .. [[">]])
    end
    cgilua.print(name)
    cgilua.print([[</a>]])
    cgilua.print([[</li>]])
end

-- Build navbar HTML code
function build_navbar_tree(dir, subdir)
    if subdir == nil then subdir = "" end
    if fnc.string.is_empty(subdir) then -- Top level
        cgilua.print([[<ul class="navbar-nav me-auto mb-2 mb-md-0">]])
    else -- Sub level
        cgilua.print([[<ul class="dropdown-menu">]])
    end
    if fnc.string.is_empty(subdir) then -- Top level
        local active = (page_info.file == "index.lp")
        navbar_add_item("Home", "/cgi-bin/app.lua", active, true)
    end
    local excludes = fnc.app.exclude_pages()
    for file in lfs.dir(dir .. "/" .. subdir) do
        if fnc.table.length(fnc.table.keys_by_value(excludes, subdir .. file)) == 0 then
            local name = fnc.app.title_by_filename(file)
            local attr = lfs.attributes(dir .. "/" .. subdir .. file)
            if attr.mode == "file" then
                if fnc.file.get_extension(file) == "lp" then
                    local url = "/cgi-bin/app.lua/" .. subdir .. file
                    local active = (page_info.file == subdir .. file)
                    local top = fnc.string.is_empty(subdir)
                    navbar_add_item(name, url, active, top)
                end
            elseif attr.mode == "directory" and file ~= "." and file ~= ".." then
                if fnc.string.is_empty(subdir) then -- Only one level of nesting
                    local class = ""
                    local active = (fnc.string.split(page_info.file, "/")[1] == file)
                    if active then class = "active" end
                    cgilua.print([[<li class="nav-item dropdown">]])
                    cgilua.print([[<a class="nav-link dropdown-toggle ]]  .. class .. [[" href="#" data-bs-toggle="dropdown" aria-expanded="false">]] .. name .. [[</a>]])
                    build_navbar_tree(dir, file .. "/")
                    cgilua.print([[</li>]])
                end
            end
        end
    end
    if fnc.string.is_empty(subdir) then -- Top level
        navbar_add_item("Instructions", "https://io-net.ru/mjsxj02hl_firmware", false, true)
        navbar_add_item("Telegram", "https://t.me/mjsxj02hl_firmware", false, true)
    end
    cgilua.print([[</ul>]])
end
%>
<!doctype html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>MJSXJ02HL: <%= page_info.title %></title>
        <link rel="icon" href="/favicon.ico">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.3/css/all.css">
        <link rel="stylesheet" href="/css/style.css">
        <script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>
    <body>
        <%
        if page_info.navbar then
            %>
            <nav class="navbar navbar-expand-md navbar-dark bg-dark mb-4">
                <div class="container-fluid">
                    <a class="navbar-brand" href="/">MJSXJ02HL</a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarCollapse"> 
                        <%
                        build_navbar_tree("pages")
                        %>
                        <div class="d-flex">
                            <a class="btn btn-outline-danger" href="<%= cgilua.authentication.logoutURL() %>">Logout</a>
                        </div>
                    </div>
                </div>
            </nav>
            <%
        end
        cgilua.lp.include("pages/" .. page_info.file, {
            cgilua = cgilua,
            required = required,
            page_info = page_info,
        })
        %>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="https://unpkg.com/bootstrap-show-password@1.2.1/dist/bootstrap-show-password.min.js"></script>
    </body>
</html>
