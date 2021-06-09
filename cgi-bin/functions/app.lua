local functions = {
    app = {},
    file = require "functions.file",
    string = require "functions.string",
}
package.loaded[...] = functions.app

-- Default page_info table
functions.app.default_page_info = function()
    return {
        file = nil,    -- Page file name
        navbar = true, -- Show navigation bar
        title = "",    -- Page title
        message = "",  -- Message for error page(s)
    }
end

-- Default mjsxj02hl application settings
functions.app.default_settings = function()
    return {
        logger = {
            level                = 2,           -- Log level
            file                 = "",          -- Write log to file
        },
        video = {
            type                 = 2,           -- Video compression standard (1 = h264, 2 = h265)
            fps                  = 20,          -- Frames per second
            flip                 = false,       -- Flip (true or false)
            mirror               = false,       -- Mirror (true or false)
        },
        audio = {
            volume               = 70,          -- Volume (0-100)
        },
        speaker = {
            volume               = 70,          -- Volume (0-100)
        },
        alarm = {
            motion_sens          = 150,         -- Motion sensitivity (1-255)
            humanoid_sens        = 150,         -- Humanoid sensitivity (1-255)
            motion_timeout       = 60,          -- Motion timeout (in seconds)
            humanoid_timeout     = 60,          -- Humanoid timeout (in seconds)
            motion_detect_exec   = "",          -- Execute the command when motion is detected
            humanoid_detect_exec = "",          -- Execute the command when humanoid is detected
            motion_lost_exec     = "",          -- Execute the command when motion is lost
            humanoid_lost_exec   = "",          -- Execute the command when humanoid is lost
        },
        mqtt = {
            server               = "",          -- Address (empty for disable)
            port                 = 1883,        -- Port
            username             = "",          -- Username (empty for anonimous)
            password             = "",          -- Password (empty for disable)
            topic                = "mjsxj02hl", -- Topic name
            qos                  = 1,           -- Quality of Service (0, 1 or 2)
            retain               = false,       -- Retained messages
        },
        night = {
            mode                 = 2,           -- Night mode (0 = off, 1 = on, 2 = auto)
            gray                 = 2,           -- Grayscale (0 = off, 1 = on, 2 = auto)
        },
    }
end

-- Default wpa_supplicant.conf settings
functions.app.default_wpa_supplicant = function()
    return {
        network = {
            scan_ssid = 1, -- SSID scan technique (0 = broadcast Probe Request, 1 = directed Probe Request)
            ssid = "",     -- Service set identifier (SSID)
            psk = "",      -- Network key (password)
        },
    }
end

-- Table of exclude pages (from navbar and direct request)
functions.app.exclude_pages = function()
    return {
        "index.lp", -- Index page
        "login.lp", -- Login page
        "error.lp", -- Error page
        "page.lp",  -- Main template
    }
end

-- Restart mjsxj02hl application
functions.app.restart = function()
    if os.execute("killall mjsxj02hl") then
        functions.app.sleep(3)
        if os.execute("mjsxj02hl &") then
            return true
        end
    end
    return false
end

-- Get page title by filename
functions.app.title_by_filename = function(filename)
    if filename then
        filename = functions.file.name_from_path(filename)
        filename = functions.file.trim_extension(filename)
        filename = functions.string.replace("_", " ", filename)
        filename = functions.string.first_letter(filename)
        return filename
    end
    return ""
end

-- Flashing the selected partition
functions.app.flash_partition = function(filename, partition)
    if functions.file.exists(filename) and functions.file.exists(partition) then
        if os.execute("flash_eraseall " .. partition) then
            if os.execute("sync") then
                if os.execute("flashcp -v " .. filename .. " " .. partition) then
                    return true
                end
            end
        end
    end
    return false
end

-- Sleep N seconds
functions.app.sleep = function(n)
    os.execute("sleep " .. tonumber(n))
end

return functions.app
