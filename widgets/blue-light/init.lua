local awful = require("awful")
local beautiful = require("beautiful")
local toggle = require("widgets.toggle")

local widget_icon_dir = beautiful.get().icons .. "widgets/blue-light/"

local state = false
local offIcon = widget_icon_dir .. "blue-light-off.svg"
local onIcon = widget_icon_dir .. "blue-light.svg"

local widget = toggle("Blue Light", offIcon, function()
  awesome.emit_signal("widgets::blue_light", false)
end)

local function update_widget()
  if state then
    widget:updateButton("On", beautiful.accent, onIcon)
  else
    widget:updateButton("Off", beautiful.groups_bg, offIcon)
  end
end

awesome.connect_signal("widgets::blue_light", function()
  awful.spawn.easy_async_with_shell(
    [[
        if [ ! -z $(pgrep redshift) ];
        then
            redshift -x && pkill redshift && killall redshift
            echo 'OFF'
        else
            redshift -l 0:0 -t 4500:4500 -r &>/dev/null &
            echo 'ON'
        fi]],
    function(stdout)
      state = stdout:match("ON")
      update_widget()
    end
  )
end)

awful.spawn.easy_async_with_shell(
  [[redshift -x
    kill -9 $(pgrep redshift)]],
  function(stdout)
    if tonumber(stdout) then
      state = false
      update_widget()
    end
  end
)

return widget
