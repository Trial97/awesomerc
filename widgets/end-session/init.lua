local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local icons = require("themes.icons")
local click_container = require("widgets.clickable-container")

local dpi = beautiful.xresources.apply_dpi

return function()
  local widget = wibox.widget({
    {
      id = "icon",
      image = icons.power,
      resize = true,
      widget = wibox.widget.imagebox,
    },
    layout = wibox.layout.align.horizontal,
  })

  local widget_button = wibox.widget({
    {
      {
        widget,
        margins = dpi(5),
        widget = wibox.container.margin,
      },
      widget = click_container,
    },
    bg = beautiful.transparent,
    shape = gears.shape.circle,
    widget = wibox.container.background,
  })

  widget_button:buttons({
    awful.button({}, 1, nil, function()
      awesome.emit_signal("module::exit_screen:show")
      awful.screen.focused().control_center:toggle()
    end),
  })
  return widget_button
end
