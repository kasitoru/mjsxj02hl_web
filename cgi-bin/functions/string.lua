local functions = {
    string = {},
}
package.loaded[...] = functions.string

-- Check if the string is empty
functions.string.is_empty = function(str)
    return (str == nil or str == "")
end

-- Escapes special pattern characters
functions.string.escape_pattern = function(str)
    if str then
        local matches = {
            ["^"] = "%^",
            ["$"] = "%$",
            ["("] = "%(",
            [")"] = "%)",
            ["%"] = "%%",
            ["."] = "%.",
            ["["] = "%[",
            ["]"] = "%]",
            ["*"] = "%*",
            ["+"] = "%+",
            ["-"] = "%-",
            ["?"] = "%?",
            ["\0"] = "%z",
        }
        return string.gsub(str, ".", matches)
    end
    return ""
end

-- Count the number of substring occurrences
functions.string.substr_count = function(str, sub)
    if str and sub then
        sub = functions.string.escape_pattern(sub)
        local _, count = string.gsub(str, sub, "")
        return count
    end
    return 0
end

-- Split the string by separator into table
functions.string.split = function(str, sep)
    local data = {}
    if str and sep then
        sep = functions.string.escape_pattern(sep)
        for part in string.gmatch(str, "([^" .. sep .. "]+)") do
            table.insert(data, part)
        end
    end
    return data
end

-- Left trim string
functions.string.ltrim = function(str, symbol)
    if str then
        if functions.string.is_empty(symbol) then
            symbol = " "
        end
        symbol = functions.string.escape_pattern(symbol)
        return string.match(str, "^" .. symbol .. "*(.-)$")
    end
    return ""
end

-- Right trim string
functions.string.rtrim = function(str, symbol)
    if str then
        if functions.string.is_empty(symbol) then
            symbol = " "
        end
        symbol = functions.string.escape_pattern(symbol)
        return string.match(str, "^(.-)" .. symbol .. "*$")
    end
    return ""
end

-- Trim string
functions.string.trim = function(str, symbol)
    if str then
        str = functions.string.ltrim(str, symbol)
        str = functions.string.rtrim(str, symbol)
        return str
    end
    return ""
end

-- Uppercase first letter
functions.string.first_letter = function(str)
    if str then
        return string.gsub(str, "^%l", string.upper)
    end
    return ""
end

-- Replace all occurrences of the search string with the replacement string
functions.string.replace = function(search, replace, subject)
    if search and subject then
        search = functions.string.escape_pattern(search)
        replace = functions.string.escape_pattern(replace)
        subject = string.gsub(subject, search, replace)
    end
    return subject
end

-- Check if the string start width substring
functions.string.start_width = function(str, start)
    if str and start then
        return (string.sub(str, 1, string.len(start)) == start)
    end
    return false
end

-- Check if the string end width substring
functions.string.end_width = function(str, ends)
    if str and ends then
        return (string.sub(str, -string.len(ends)) == ends)
    end
    return false
end

return functions.string
