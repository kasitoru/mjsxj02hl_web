local functions = {
    file = {},
    string = require "functions.string",
}
package.loaded[...] = functions.file

-- Check if the file (or dir) exists
functions.file.exists = function(filename)
    if io.open(filename) then
        return true
    else
        return false
    end
end

-- Check is a dir and it exists
functions.file.is_dir = function(dirname)
    dirname = functions.string.rtrim(dirname, "/")
    if functions.file.exists(dirname .. "/") then
        return true
    else
        return false
    end
end

-- Check is a dir and it exists
functions.file.is_file = function(filename)
    return (functions.file.exists(filename) and (not functions.file.is_dir(filename)))
end

-- Save the file submitted from form
functions.file.save_post = function(post_file, filename)
    local file_length = 0
    local file_error = nil
    if (post_file and post_file.file and (type(post_file.file) == "file")) then
        local out_file, file_error = io.open(filename, "wb")
        if out_file then
            repeat
                local bytes = post_file.file:read(1024)
                if bytes then
                    out_file:write(bytes)
                else
                    out_file:flush()
                end
            until not bytes
            file_length, file_error = out_file:seek()
            out_file:close()
            if file_error then
                os.remove(filename)
            end
        end
    else
        file_error = "Bad post file"
    end
    return file_length, file_error
end

-- Get file contents
functions.file.get_contents = function(filename)
    local file_data = ""
    local file_error = nil
    local file, file_error = io.open(filename, "rb")
    if file then
        file_data = file:read("*a")
        file:close()
    end
    return file_data, file_error
end

-- Get filename from path
functions.file.name_from_path = function(filepath)
    if not functions.string.is_empty(filepath) then
        return filepath:match("([^/\\]*)$")
    end
    return ""
end

-- Return filename without extension
functions.file.trim_extension = function(filename)
    if not functions.string.is_empty(filename) then
        local trimmed = filename:match("(.*)(%.(.*))$")
        if functions.string.is_empty(trimmed) then trimmed = filename end
        return trimmed
    end
    return ""
end

-- Get extension of filename
functions.file.get_extension = function(filename)
    if not functions.string.is_empty(filename) then
        return filename:match("([^.]*)$")
    end
    return ""
end

-- Read wpa_supplicant.conf to table
-- TODO: Write universal code
functions.file.read_wpa_supplicant = function(filename)
    local wpa_data, wpa_error = {}, nil
    local content = functions.file.get_contents(filename)
    -- network
    local network = string.match(content, "network[%s]*=[%s]*{(.-)}")
    if network then
        wpa_data["network"] = {}
        -- network.scan_ssid
        local scan_ssid = string.match(network, "[%s]+scan_ssid=[%s]*(%S*)[%s]*")
        if scan_ssid then
            wpa_data["network"]["scan_ssid"] = functions.string.trim(scan_ssid, '"')
        end
        -- network.ssid
        local ssid = string.match(network, "[%s]+ssid=[%s]*(%S*)[%s]*")
        if ssid then
            wpa_data["network"]["ssid"] = functions.string.trim(ssid, '"')
        end
        -- network.psk
        local psk = string.match(network, "[%s]+psk=[%s]*(%S*)[%s]*")
        if psk then
            wpa_data["network"]["psk"] = functions.string.trim(psk, '"')
        end
    end
    return wpa_data, wpa_error
end

-- Build wpa_supplicant.conf content from table
functions.file.build_wpa_supplicant = function(tbl, _tab)
    if not _tab then _tab = 0 end
    local wpa_content, wpa_error = "", nil
    if type(tbl) == "table" then
        for key, value in pairs(tbl) do
            if type(value) == "table" then
                wpa_content = wpa_content .. string.rep("    ", _tab) .. key .. "={\r\n";
                wpa_content = wpa_content .. functions.file.build_wpa_supplicant(value, _tab + 1)
                wpa_content = wpa_content .. string.rep("    ", _tab) .. "}\r\n";
            elseif type(value) == "number" then
                wpa_content = wpa_content .. string.rep("    ", _tab) .. key .. "=" .. value .. "\r\n";
            else
                wpa_content = wpa_content .. string.rep("    ", _tab) .. key .. '="' .. tostring(value) .. '"\r\n';
            end
        end
    else
        wpa_error = "Parameter 2 is a " .. type(tbl) .. " instead of a table"
    end
    return wpa_content, wpa_error
end

-- Save wpa_supplicant.conf from table
functions.file.save_wpa_supplicant = function(filename, tbl)
    local wpa_result, wpa_content, wpa_error = false, "", nil
    local wpa_file, wpa_error = io.open(filename, "w")
    if wpa_file then
        wpa_content, wpa_error = functions.file.build_wpa_supplicant(tbl)
        if not wpa_error then
            wpa_file:write(wpa_content)
            wpa_result = true
        end
        wpa_file:close()
    end
    return wpa_result, wpa_error
end

return functions.file
