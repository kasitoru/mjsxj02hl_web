-- CGILua (https://github.com/keplerproject/cgilua)
cgilua.authentication = require "cgilua.authentication" -- Authentication
cgilua.lp = require "cgilua.lp" -- Lua Pages

-- Other
required = function()
    return {
        -- Basic Functions
        lua = {
            next     = next, -- Allows a program to traverse all fields of a table (https://www.lua.org/manual/5.4/manual.html#pdf-next)
            tonumber = tonumber, -- Tries to convert its argument to a number (https://www.lua.org/manual/5.4/manual.html#pdf-tonumber)
        },
        
        -- Internal
        io = require "io", -- Input and Output Facilities (https://www.lua.org/manual/5.4/manual.html#6.8)
        os = require "os", -- Operating System Facilities (https://www.lua.org/manual/5.4/manual.html#6.9)
        
        -- External
        lfs  = require "lfs", -- LuaFileSystem - File System Library for Lua (https://github.com/keplerproject/luafilesystem)
        md5  = require "md5", -- MD5 - Cryptographic Library for Lua (https://github.com/keplerproject/md5)
        ldes = require "ldes", -- Standart UNIX crypt for Lua (https://github.com/avdeevsv91/luades)
        lip  = require "LIP", -- Lua INI Parser (https://github.com/Dynodzzo/Lua_INI_Parser)
        fnc  = require "functions", -- Custom functions (functions/init.lua)
    }
end

