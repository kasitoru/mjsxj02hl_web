#!/usr/app/bin/cgilua.cgi

cgilua.doif("required.lua")
cgilua.doif("auth.lua")

local fnc = required().fnc

local page_info = fnc.app.default_page_info()

if not fnc.file.exists("/configs/wpa_supplicant.conf") then
    page_info.file = "initial.lp"
    page_info.title = "Setup"
    cgilua.htmlheader()
    cgilua.lp.include("pages/initial.lp", {
        cgilua = cgilua,
        required = required(),
        page_info = page_info,
    })
else
    if cgilua.authentication then
        if not cgilua.authentication.username() then
            cgilua.redirect(cgilua.authentication.checkURL())
            return
        else
            page_info.file = fnc.string.ltrim(cgilua.script_vpath, "/")
            if fnc.string.is_empty(page_info.file) then
                if fnc.file.exists("pages/index.lp") then
                    page_info.file = "index.lp"
                end
            elseif (fnc.file.get_extension(page_info.file) ~= "lp") 
            or (fnc.table.length(fnc.table.keys_by_value(fnc.app.exclude_pages(), page_info.file)) > 0)
            or (not fnc.file.exists("pages/" .. page_info.file))
            then
                page_info.file = "error.lp"
                page_info.navbar = false
                page_info.title = "Error 404"
                page_info.message = "Not Found!"
            end
            if fnc.string.is_empty(page_info.title) then
                page_info.title = fnc.app.title_by_filename(page_info.file)
            end
        end
    else
        page_info.file = "error.lp"
        page_info.navbar = false
        page_info.title = "CGILua error"
        page_info.message = "No authentication configured!"
    end
    cgilua.htmlheader()
    cgilua.lp.include("pages/page.lp", {
        cgilua = cgilua,
        required = required(),
        page_info = page_info,
    })
end
