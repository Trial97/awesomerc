local awful = require("awful")
local icons = require("themes.icons")
local slider = require("widgets.slider")

local spawn = awful.spawn
local curent_value = 0
local function updateCurentValue(level)
  level = tonumber(level)
  if level ~= 0 then
    curent_value = level
  end
end
local mic_slider = slider("Microphone", icons.mic, function(level)
  spawn("amixer -D pulse sset Capture " .. level .. "%", false)
  updateCurentValue(level)
end)

local function update_slider(first)
  awful.spawn.easy_async_with_shell([[bash -c "amixer -D pulse sget Capture"]], function(stdout)
    local volume = string.match(stdout, "(%d?%d?%d)%%")
    mic_slider:set_value(tonumber(volume))
    updateCurentValue(volume)
    if not first then
      awesome.emit_signal("modules::mic_osd", tonumber(volume))
    end
  end)
end

-- Update on startup
update_slider(true)

-- The emit will come from the global keybind
awesome.connect_signal("widgets::mic", update_slider)
awesome.connect_signal("widgets::mic:update", function(level)
  updateCurentValue(tonumber(level))
  mic_slider:set_value(tonumber(level))
end)
awesome.connect_signal("widgets::mic:do", function(value)
  local level = mic_slider:get_value()
  if value == 0 then
    if level == 0 then
      level = curent_value
    else
      level = 0
    end
  else
    level = level + value
  end
  updateCurentValue(level)
  mic_slider:set_value(level)
  awesome.emit_signal("modules::mic_osd", level, icons.getLevelIcon("microphone-sensitivity", level))
end)

return mic_slider
