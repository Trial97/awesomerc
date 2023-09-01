local awful = require("awful")
local icons = require("themes.icons")
local slider = require("widgets.slider")

local spawn = awful.spawn
local volume_slider = slider("Volume", icons.volume, function(level)
  spawn("amixer -D pulse sset Master " .. level .. "%", false)
end)

local function update_slider(first)
  awful.spawn.easy_async_with_shell([[bash -c "amixer -D pulse sget Master"]], function(stdout)
    local volume = string.match(stdout, "(%d?%d?%d)%%")
    volume_slider:set_value(tonumber(volume))
    if not first then
      awesome.emit_signal("modules::volume_osd", tonumber(volume))
    end
  end)
end

-- Update on startup
update_slider(true)

-- The emit will come from the global keybind
awesome.connect_signal("widgets::volume", update_slider)
awesome.connect_signal("widgets::volume:update", function(level)
  volume_slider:set_value(tonumber(level))
end)

return volume_slider
