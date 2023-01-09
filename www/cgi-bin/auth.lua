local fnc = required().fnc
local md5 = required().md5
local ldes = required().ldes

-- Calculate crypto key
local wpa_content = fnc.file.get_contents(fnc.app.wpa_supplicant_file())
local crypto_key = md5.sumhexa(wpa_content)

-- Set authentication options
local options = {
    method = "passwd",
    tokenPersistence="cookie",
    tokenName = "session",
    criptKey=crypto_key,
    checkURL="/cgi-bin/login.lua",
}

-- Authentication method
local methods = {
    passwd = {
        check = function(username, password)
            local file = io.open("/etc/passwd", "r")
            if fnc.file.is_file_descriptor(file) then
                local user_found = false
                for line in file:lines() do
                    local counter = 0
                    for part in string.gmatch(line, '([^:]+)') do
                        if (counter == 0) and (part == username) then
                            user_found = true
                        elseif (counter == 1) and user_found then
                            local salt = string.sub(part, 1, 2)
                            if part == ldes.crypt(password, salt) then
                                return true
                            end
                            break
                        else break end
                        counter = counter + 1
                    end
                    if user_found then break end
                end
                file:close()
                return false, "Wrong user/password combination!"
            else
                return false, "Can't open file /etc/passwd!"
            end
        end
    }
}

cgilua.authentication.configure(options, methods)
