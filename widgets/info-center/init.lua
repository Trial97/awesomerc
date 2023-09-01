local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local panel_width = dpi(350)

awesome.connect_signal("widgets::info_center:toggle", function(open)
  local focused = awful.screen.focused()
  for s in screen do
    if s.info_center == nil then
      return
    end
    if s ~= focused then
      s.info_center:toggle(false)
    else
      s.info_center:toggle(open)
    end
  end
end)

return function(s)
  -- Set the info center geometry
  local panel = awful.popup({
    widget = {
      {
        {
          layout = wibox.layout.fixed.vertical,
          forced_width = panel_width,
          spacing = dpi(10),
          require("widgets.notif-center")(),
        },
        margins = dpi(16),
        widget = wibox.container.margin,
      },
      id = "info_center",
      bg = beautiful.background,
      shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, beautiful.groups_radius)
      end,
      widget = wibox.container.background,
    },
    screen = s,
    type = "dock",
    visible = false,
    ontop = true,
    width = panel_width,
    maximum_width = panel_width,
    maximum_height = dpi(s.geometry.height - 38),
    bg = beautiful.transparent,
    fg = beautiful.fg_normal,
    shape = gears.shape.rectangle,
  })

  awful.placement.top_right(panel, {
    honor_workarea = true,
    parent = s,
    margins = {
      top = dpi(33),
      right = dpi(5),
    },
  })

  panel.opened = false

  panel.backdrop = wibox({
    ontop = true,
    screen = s,
    bg = beautiful.transparent,
    type = "utility",
    x = s.geometry.x,
    y = s.geometry.y,
    width = s.geometry.width,
    height = s.geometry.height,
  })

  function panel:toggle(open)
    if open == self.opened then
      return
    end
    self.opened = not self.opened
    if open ~= nil then
      self.opened = open
    end
    self.backdrop.visible = self.opened
    self.visible = self.opened
    if self.opened then
      self:emit_signal("opened")
    else
      self:emit_signal("closed")
    end
  end
  panel.backdrop:buttons({ awful.button({}, 1, nil, function()
    awesome.emit_signal("widgets::info_center:toggle")
  end) })
  return panel
end
