local functions = {
    app = {},
    file = require "functions.file",
    string = require "functions.string",
    number = require "functions.number",
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
        general = {
            led = true,                            -- Enable onboard LED indicator
        },
        logger = {
            level                   = 2,           -- Log level (0 = disabled, 1 = error, 2 = warning, 3 = info, 4 = debug)
            file                    = "",          -- Write log to file
        },
        osd = {
            enable                  = false,       -- Enable On-Screen Display (OSD)
            oemlogo                 = true,        -- Display OEM logo (MI)
            oemlogo_x               = 2,           -- X position of the OEM logo
            oemlogo_y               = 0,           -- Y position of the OEM logo
            oemlogo_size            = 0,           -- Size of the OEM logo (can take negative values)
            datetime                = true,        -- Display date and time
            datetime_x              = 48,          -- X position of the date and time
            datetime_y              = 0,           -- Y position of the date and time
            datetime_size           = 0,           -- Size of the date and time (can take negative values)
            motion                  = false,       -- Display detected motions in rectangles
            humanoid                = false,       -- Display detected humanoids in rectangles
        },
        video = {
            gop                     = 1,           -- Group of pictures (GOP) every N*FPS (20)
            flip                    = false,       -- Flip image (all channels)
            mirror                  = false,       -- Mirror image (all channels)
            primary_enable          = true,        -- Enable video for primary channel
            secondary_enable        = true,        -- Enable video for secondary channel
            primary_type            = 1,           -- Video compression standard for primary channel (1 = h264, 2 = h265)
            secondary_type          = 1,           -- Video compression standard for secondary channel (1 = h264, 2 = h265)
            primary_bitrate         = 1800,        -- Bitrate for primary channel
            secondary_bitrate       = 900,         -- Bitrate for secondary channel
            primary_rcmode          = 2,           -- Rate control mode for primary channel (0 = constant bitrate, 1 = constant quality, 2 = variable bitrate)
            secondary_rcmode        = 2,           -- Rate control mode for secondary channel (0 = constant bitrate, 1 = constant quality, 2 = variable bitrate)
        },
        audio = {
            volume                  = 70,          -- Volume (0-100)
            primary_enable          = true,        -- Enable audio for primary channel
            secondary_enable        = true,        -- Enable audio for secondary channel
        },
        speaker = {
            volume                  = 70,          -- Volume (0-100)
            type                    = 1,           -- Default file format (1 = PCM, 2 = G711)
        },
        alarm = {
            motion_sens             = 150,         -- Motion sensitivity (1-255)
            humanoid_sens           = 150,         -- Humanoid sensitivity (1-255)
            motion_timeout          = 60,          -- Motion timeout (in seconds)
            humanoid_timeout        = 60,          -- Humanoid timeout (in seconds)
            motion_detect_exec      = "",          -- Execute the command when motion is detected
            humanoid_detect_exec    = "",          -- Execute the command when humanoid is detected
            motion_lost_exec        = "",          -- Execute the command when motion is lost
            humanoid_lost_exec      = "",          -- Execute the command when humanoid is lost
        },
        rtsp = {
            enable                  = true,        -- Enable RTSP server
            port                    = 554,         -- Port number
            username                = "",          -- Username (empty for disable)
            password                = "",          -- Password
            primary_name            = "primary",   -- Name of the primary channel
            secondary_name          = "secondary", -- Name of the secondary channel
            primary_multicast       = false,       -- Use multicast for primary channel
            secondary_multicast     = false,       -- Use multicast for secondary channel
            primary_split_vframes   = true,        -- Split video frames into separate packets for primary channel
            secondary_split_vframes = true,        -- Split video frames into separate packets for secondary channel
        },
        mqtt = {
            enable                  = false,       -- Enable MQTT client
            server                  = "",          -- Address (empty for disable)
            port                    = 1883,        -- Port
            username                = "",          -- Username (empty for anonimous)
            password                = "",          -- Password (empty for disable)
            topic                   = "mjsxj02hl", -- Topic name
            qos                     = 1,           -- Quality of Service (0, 1 or 2)
            retain                  = false,       -- Retained messages
        },
        night = {
            mode                    = 2,           -- Night mode (0 = off, 1 = on, 2 = auto)
            gray                    = 2,           -- Grayscale (0 = off, 1 = on, 2 = auto)
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
        "initial.lp", -- Initial setup
        "index.lp",   -- Index page
        "login.lp",   -- Login page
        "error.lp",   -- Error page
        "page.lp",    -- Main template
    }
end

-- Restart mjsxj02hl application
functions.app.restart = function()
    -- Kill application
    os.execute("killall mjsxj02hl")
    -- Waiting for completion
    while os.execute("killall -0 mjsxj02hl") do
        functions.app.sleep(1)
    end
    -- Run application
    return os.execute("mjsxj02hl & sleep 0.1")
end

-- Get page title by filename
functions.app.title_by_filename = function(filename)
    if functions.string.is_string(filename) then
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
    if functions.string.is_string(filename) and functions.string.is_string(partition) then
        if functions.file.exists(filename) and functions.file.exists(partition) then
            if os.execute("flash_eraseall " .. partition) then
                if os.execute("sync") then
                    if os.execute("flashcp -v " .. filename .. " " .. partition) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- Sleep N seconds
functions.app.sleep = function(n)
    if functions.number.is_number(n) then
        if os.execute("sleep " .. n) then
            return true
        end
    end
    return false
end

return functions.app
