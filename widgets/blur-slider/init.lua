local awful = require('awful')
local icons = require('themes.icons')
local slider = require('widgets.slider')

local spawn = awful.spawn
local start_up = true
local blur_slider = slider('Blur Strength', icons.effects, function(level)
  if start_up then
    return
  end
  local power = level / 50 * 10
  awful.spawn.with_shell([[bash -c "
    sed -i 's/.*strength = .*/    strength = ]] .. tostring(power):gsub(',', '.') .. [[;/g' \
    $HOME/.config/picom/picom.conf
    "]])
end)

local function update_slider(first)
  awful.spawn.easy_async_with_shell(
    [[bash -c "grep -F 'strength =' $HOME/.config/picom/picom.conf |
        awk 'NR==1 {print $3}' | tr -d ';'"]],
    function(stdout, stderr)
      local strength = stdout:match('%d+')
      if strength~=nil then
        local blur_strength = tonumber(strength) / 20 * 100
        blur_slider:set_value(tonumber(blur_strength))
      end
      start_up = false
    end
  )
end

-- Update on startup
update_slider(true)

-- The emit will come from the global keybind
awesome.connect_signal('widgets::blur', update_slider)

-- Adjust slider value to change blur strength
awesome.connect_signal('widgets::blur:increase', function()
  -- On startup, the slider.value returns nil so...
  if blur_slider:get_value() == nil then
    return
  end

  local blur_value = blur_slider:get_value() + 10

  -- No more than 100!
  if blur_value > 100 then
    blur_value = 100
  end

  blur_slider:set_value(blur_value)
end)

-- Decrease blur
awesome.connect_signal('widgets::blur:decrease', function()
  -- On startup, the slider.value returns nil so...
  if blur_slider:get_value() == nil then
    return
  end

  local blur_value = blur_slider:get_value() - 10

  -- No negatives!
  if blur_value < 0 then
    blur_value = 0
  end

  blur_slider:set_value(blur_value)
end)

return blur_slider
