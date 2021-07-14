local functions = {
    table = {},
    string = require "functions.string",
}
package.loaded[...] = functions.table

-- Checks if the passed argument is a table
functions.table.is_table = function(tbl)
    return (type(tbl) == "table")
end

-- Get table value by key
functions.table.value_by_key = function(tbl, key)
    if (type(tbl) == 'table') and key then
        for k, value in pairs(tbl) do
            if k == key then
                return value
            end
        end
    end
    return nil
end

-- Get table keys by value
functions.table.keys_by_value = function(tbl, value)
    local tbl_keys = {}
    if (type(tbl) == 'table') and value then
        for key, v in pairs(tbl) do
            if v == value then
                table.insert(tbl_keys, key)
            end
        end
    end
    return tbl_keys
end

-- Get table length
functions.table.length = function(tbl)
    local count = 0
    if type(tbl) == 'table' then
        for _ in pairs(tbl) do
            count = count + 1
        end
    end
    return count
end

-- Copy table to new instance
functions.table.copy = function(tbl)
    local out = {}
    for key, value in pairs(tbl) do
        if type(value) == "table" then
            out[key] = functions.table.copy(value)
        else
            out[key] = value
        end
    end
    return out
end

-- Merge two tables
functions.table.merge = function(tbl1, tbl2)
    local out = functions.table.copy(tbl1)
    for key, value in pairs(tbl2) do
        if type(value) == "table" then
            out[key] = functions.table.merge(out[key], value)
        else
            out[key] = value
        end
    end
    return out
end

return functions.table
