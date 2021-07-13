local functions = {
    file = {},
    string = require "functions.string",
    table = require "functions.table",
    number = require "functions.number",
}
package.loaded[...] = functions.file

-- Check if the file (or dir) exists
functions.file.exists = function(filename)
    if functions.string.is_string(filename) then
        if io.open(filename) then
            return true
        end
    end
    return false
end

-- Check is a dir and it exists
functions.file.is_dir = function(dirname)
    if functions.string.is_string(dirname) then
        dirname = functions.string.rtrim(dirname, "/")
        if functions.file.exists(dirname .. "/") then
            return true
        end
    end
    return false
end

-- Check is a dir and it exists
functions.file.is_file = function(filename)
    if functions.string.is_string(filename) then
        return (functions.file.exists(filename) and (not functions.file.is_dir(filename)))
    end
    return false
end

-- Checks if the passed argument is a file descriptor
functions.file.is_file_descriptor = function(file)
    return (io.type(file) == "file")
end

-- Save the file submitted from form
functions.file.save_post = function(post_file, filename)
    local file_length = 0
    local file_error = nil
    if (post_file and post_file.file and functions.file.is_file_descriptor(post_file.file)) then
        if functions.string.is_string(filename) then
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
            file_error = "Incorrect filename"
        end
    else
        file_error = "Incorrect file descriptor"
    end
    return file_length, file_error
end

-- Get file contents
functions.file.get_contents = function(filename)
    local file_data = ""
    local file_error = nil
    if functions.string.is_string(filename) then
        local file, file_error = io.open(filename, "rb")
        if file then
            file_data = file:read("*a")
            file:close()
        end
    else
        file_error = "Incorrect filename"
    end
    return file_data, file_error
end

-- Put file contents
functions.file.put_contents = function(filename, content)
    local result = false
    local file_error = nil
    if functions.string.is_string(filename) then
        local file, file_error = io.open(filename, "wb")
        if file then
            file:write(content)
            file:close()
            result = true
        end
    else
        file_error = "Incorrect filename"
    end
    return result, file_error
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

-- Parser of the open wpa_supplicant.conf file to the table
functions.file.parse_wpa_supplicant = function(wpa_file)
    local wpa_content, wpa_error = {}, nil
    if functions.file.is_file_descriptor(wpa_file) then
        for line in wpa_file:lines() do
            local param, value = line:match("^%s*([%w|_]+)%s*=%s*(.*)[\r]?$")
            if param and value ~= nil then
                value = value:match("^(.-)%s-;.-$") or value:match("^(.-)%s-$")
                if value == "{" then
                    wpa_content[param], wpa_error = functions.file.parse_wpa_supplicant(wpa_file)
                    if wpa_error then break end
                else
                    local strval = value:match('^"(.*)"$')
                    if strval then
                        value = strval
                    elseif tonumber(value) then
                        value = tonumber(value)
                    else
                        value = tostring(value)
                    end
                    wpa_content[param] = value
                end
            elseif line:match("^%s*}%s*[\r]?$") then
                break
            end
        end
    else
        wpa_error = "Incorrect file descriptor"
    end
    return wpa_content, wpa_error
end

-- Read wpa_supplicant.conf to table
functions.file.read_wpa_supplicant = function(filename)
    local wpa_result, wpa_content, wpa_error = false, {}, nil
    if functions.string.is_string(filename) then
        local wpa_file, wpa_error = io.open(filename, "r")
        if wpa_file then
            wpa_content, wpa_error = functions.file.parse_wpa_supplicant(wpa_file)
            wpa_file:close()
        end
    else
        wpa_error = "Incorrect filename"
    end
    return wpa_content, wpa_error
end

-- Build wpa_supplicant.conf content from table
functions.file.build_wpa_supplicant = function(tbl, _tab)
    if not _tab then _tab = 0 end
    local wpa_content, wpa_error = "", nil
    if functions.table.is_table(tbl) then
        for key, value in pairs(tbl) do
            if functions.table.is_table(value) then
                wpa_content = wpa_content .. string.rep("    ", _tab) .. key .. "={\r\n";
                wpa_content = wpa_content .. functions.file.build_wpa_supplicant(value, _tab + 1)
                wpa_content = wpa_content .. string.rep("    ", _tab) .. "}\r\n";
            elseif functions.number.is_number(value) then
                wpa_content = wpa_content .. string.rep("    ", _tab) .. key .. "=" .. value .. "\r\n";
            else
                wpa_content = wpa_content .. string.rep("    ", _tab) .. key .. '="' .. tostring(value) .. '"\r\n';
            end
        end
    else
        wpa_error = "Incorrect table"
    end
    return wpa_content, wpa_error
end

-- Save wpa_supplicant.conf from table
functions.file.save_wpa_supplicant = function(filename, tbl)
    local wpa_result, wpa_content, wpa_error = false, "", nil
    if functions.string.is_string(filename) then
        if functions.table.is_table(tbl) then
            wpa_content, wpa_error = functions.file.build_wpa_supplicant(tbl)
            if not wpa_error then
                wpa_result, wpa_error = functions.file.put_contents(filename, wpa_content)
            end
        else
            wpa_error = "Incorrect table"
        end
    else
        wpa_error = "Incorrect filename"
    end
    return wpa_result, wpa_error
end

return functions.file
