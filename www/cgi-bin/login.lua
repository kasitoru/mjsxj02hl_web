#!/usr/app/bin/cgilua.cgi

cgilua.doif("required.lua")

local fnc = required().fnc

local page_info = fnc.app.default_page_info()
page_info.file    = "login.lp"
page_info.path    = nil
page_info.navbar  = false
page_info.title   = "Login"
page_info.message = ""

cgilua.doif("auth.lua")

local username = cgilua.POST.username
local password = cgilua.POST.password

local logged

if cgilua.authentication then
    logged, page_info.message = cgilua.authentication.check(username, password)
else
    logged = false
    page_info.message = "No authentication configured!"
end

if logged then
    local redirect_url = "/"
    if not fnc.string.is_empty(cgilua.QUERY.ref) then
        redirect_url = cgilua.authentication.refURL()
    end
	cgilua.redirect(redirect_url)
else
    cgilua.htmlheader()
    cgilua.lp.include("pages/page.lp", {
        cgilua = cgilua,
        required = required(),
        page_info = page_info,
    })
end
