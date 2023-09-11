local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
local click_container = require('widgets.clickable-container')

local dpi = beautiful.xresources.apply_dpi

local widget_icon_dir = beautiful.get().icons .. 'widgets/control-center-toggle/'

return function(s)
  local widget = wibox.widget({
    {
      id = 'icon',
      image = widget_icon_dir .. 'control-center.svg',
      widget = wibox.widget.imagebox,
      resize = true,
    },
    layout = wibox.layout.align.horizontal,
  })

  local widget_button = wibox.widget({
    {
      widget,
      margins = dpi(7),
      widget = wibox.container.margin,
    },
    widget = click_container,
  })

  widget_button:buttons({
    awful.button({}, 1, nil, function()
      awesome.emit_signal('widgets::control_center:toggle')
    end),
    awful.button({}, 3, nil, function()
      awesome.emit_signal('widgets::info_center:toggle')
    end),
  })

  return widget_button
end
