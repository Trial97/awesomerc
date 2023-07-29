local awful  = require('awful')
local icons  = require('themes.icons')
local slider = require("widgets.slider")

local spawn = awful.spawn
local brightness_slider = slider("Brightness", icons.brightness, function(level)
    spawn('light -S ' .. math.max(level, 5), false)
end)

local function update_slider(first)
    awful.spawn.easy_async_with_shell(
        'light -G', 
        function(stdout)
            local brightness = string.match(stdout, '(%d+)')
            brightness_slider:set_value(tonumber(brightness))
            if not first then 
                awesome.emit_signal('modules::brightness_osd', tonumber(brightness)) 
            end
        end
    )
end

-- Update on startup
update_slider(true)

-- The emit will come from the global keybind
awesome.connect_signal('widgets::brightness', update_slider)

return brightness_slider
