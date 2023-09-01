local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi

local function _format_item(widget, forced_height)
  return wibox.widget({
    {
      {
        layout = wibox.layout.align.vertical,
        expand = "none",
        nil,
        widget,
        nil,
      },
      margins = dpi(10),
      widget = wibox.container.margin,
    },
    forced_height = forced_height,
    bg = beautiful.groups_bg,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
    end,
    widget = wibox.container.background,
  })
end
local function format_item(widget)
  return _format_item(widget, dpi(88))
end

local function format_item_no_fix_height(widget)
  return _format_item(widget, nil)
end

local vertical_separator = wibox.widget({
  orientation = "vertical",
  forced_height = dpi(1),
  forced_width = dpi(1),
  span_ratio = 0.55,
  widget = wibox.widget.separator,
})

local control_center_row_one = wibox.widget({
  layout = wibox.layout.align.horizontal,
  forced_height = dpi(48),
  nil,
  format_item(require("widgets.user-profile")),
  {
    format_item({
      layout = wibox.layout.fixed.horizontal,
      spacing = dpi(10),
      require("widgets.end-session")(),
    }),
    left = dpi(10),
    widget = wibox.container.margin,
  },
})

local main_control_row_two = wibox.widget({
  layout = wibox.layout.flex.horizontal,
  spacing = dpi(10),
  format_item_no_fix_height({
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(5),
    require("evil.airplane-mode"),
    require("widgets.blue-light"),
    nil,
  }),
  {
    layout = wibox.layout.flex.vertical,
    spacing = dpi(10),
    format_item_no_fix_height({
      layout = wibox.layout.align.vertical,
      expand = "none",
      nil,
      require("widgets.dont-disturb"),
      nil,
    }),
    format_item_no_fix_height({
      layout = wibox.layout.align.vertical,
      expand = "none",
      nil,
      require("widgets.blur-toggle"),
      nil,
    }),
  },
})

local main_control_row_sliders = wibox.widget({
  layout = wibox.layout.fixed.vertical,
  spacing = dpi(10),
  format_item({
    require("widgets.blur-slider"),
    margins = dpi(10),
    widget = wibox.container.margin,
  }),
  format_item({
    require("widgets.brightness-slider"),
    margins = dpi(10),
    widget = wibox.container.margin,
  }),
  format_item({
    require("widgets.volume-slider"),
    margins = dpi(10),
    widget = wibox.container.margin,
  }),
  format_item({
    require("widgets.mic-slider"),
    margins = dpi(10),
    widget = wibox.container.margin,
  }),
})

local main_control_music_box = wibox.widget({
  layout = wibox.layout.fixed.vertical,
  format_item({
    require("evil.playerctl"),
    margins = dpi(10),
    widget = wibox.container.margin,
  }),
})

awesome.connect_signal("widgets::control_center:toggle", function(open)
  local focused = awful.screen.focused()
  for s in screen do
    if s.control_center == nil then
      return
    end
    if s ~= focused then
      s.control_center:toggle(false)
    else
      s.control_center:toggle(open)
    end
  end
end)

return function(s)
  -- Set the control center geometry
  local panel_width = dpi(400)

  local panel = awful.popup({
    widget = {
      {
        {
          layout = wibox.layout.fixed.vertical,
          spacing = dpi(10),
          control_center_row_one,
          {
            id = "main_control",
            visible = true,
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(10),
            main_control_row_two,
            main_control_row_sliders,
            main_control_music_box,
          },
        },
        margins = dpi(16),
        widget = wibox.container.margin,
      },
      id = "control_center",
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

  panel.backdrop:buttons({
    awful.button({}, 1, nil, function()
      awesome.emit_signal("widgets::control_center:toggle")
    end),
  })
  return panel
end
