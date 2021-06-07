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

return functions.file
