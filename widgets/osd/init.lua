local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi

local function hideOnScreen(s, name)
  for k, v in pairs(s.osds) do
    if string.find(k, "_osd") and not (name and string.find(k, name)) then
      v.visible = false
    end
  end
end

local function hide(focused, name)
  for s in screen do
    if s ~= focused then
      hideOnScreen(s)
    else
      hideOnScreen(s, name)
    end
  end
end

local hide_osd = gears.timer({
  timeout = 2,
  autostart = true,
  callback = hide,
})

local function rerun()
  if hide_osd.started then
    hide_osd:again()
  else
    hide_osd:start()
  end
end

return function(name, text, icon, update_value)
  name = name .. "_osd"
  local baseName = "modules::" .. name

  awesome.connect_signal(baseName .. ":show", function(open)
    local focused = awful.screen.focused()
    local widget = focused[name]
    awful.placement.bottom(widget, {
      preferred_positions = "top",
      preferred_anchors = "middle",
      geometry = focused.top_panel,
      offset = { x = 0, y = dpi(-100) },
    })

    widget.visible = open
    if open then
      hide(focused, name)
      rerun()
    else
      hide()
      if hide_osd.started then
        hide_osd:stop()
      end
    end
  end)

  local osd_header = wibox.widget({
    text = text,
    font = "Inter Bold 12",
    align = "left",
    valign = "center",
    widget = wibox.widget.textbox,
  })

  local osd_value = wibox.widget({
    text = "0%",
    font = "Inter Bold 12",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
  })

  local slider_osd = wibox.widget({
    nil,
    {
      id = "osd_slider",
      bar_shape = gears.shape.rounded_rect,
      bar_height = dpi(24),
      bar_color = "#ffffff20",
      bar_active_color = "#f2f2f2EE",
      handle_color = "#ffffff",
      handle_shape = gears.shape.circle,
      handle_width = dpi(24),
      handle_border_color = "#00000012",
      handle_border_width = dpi(1),
      maximum = 100,
      widget = wibox.widget.slider,
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical,
  })

  local osd_slider = slider_osd.osd_slider
  local pressed = false

  osd_slider:connect_signal("property::value", function()
    local level = osd_slider:get_value()
    -- Update textbox widget text
    osd_value.text = level .. "%"
    local focused = awful.screen.focused()
    -- if focused[name].visible then
    awesome.emit_signal(baseName .. ":show", true)
    -- end
    -- if pressed then
    update_value(level, pressed)
    -- end
  end)

  osd_slider:connect_signal("button::press", function()
    pressed = true
  end)

  osd_slider:connect_signal("mouse::enter", function() end)
  osd_slider:connect_signal("mouse::leave", function()
    pressed = false
  end)
  osd_slider:connect_signal("button::release", function()
    pressed = false
  end)

  local icon = wibox.widget({
    { id = "cover", image = icon, resize = true, widget = wibox.widget.imagebox },
    forced_height = dpi(150),
    top = dpi(12),
    bottom = dpi(12),
    widget = wibox.container.margin,
  })

  local prev_image = nil
  -- The emit will come from volume slider
  awesome.connect_signal(baseName, function(volume, app_icon)
    pressed = false
    osd_slider:set_value(volume)
    if app_icon then
      icon.cover:set_image(beautiful.get().icons .. app_icon .. ".svg")
      icon:emit_signal("widget::redraw_needed")
      if app_icon ~= prev_image then
        awesome.emit_signal(baseName .. ":show", true)
      end
      prev_image = app_icon
    end
  end)
  local osd_height = dpi(250)
  local osd_width = dpi(250)
  local osd_margin = dpi(10)

  return function(s)
    local s = s or {}

    local volume_osd = awful.popup({
      widget = {
        -- Removing this block will cause an error...
      },
      ontop = true,
      visible = false,
      type = "notification",
      screen = s,
      height = osd_height,
      width = osd_width,
      maximum_height = osd_height,
      maximum_width = osd_width,
      offset = dpi(5),
      shape = gears.shape.rectangle,
      bg = beautiful.transparent,
      preferred_anchors = "middle",
      preferred_positions = { "left", "right", "top", "bottom" },
    })
    local osds = s.osds or {}
    osds[name] = volume_osd
    s[name] = volume_osd
    s.osds = osds

    volume_osd:setup({
      {
        {
          layout = wibox.layout.fixed.vertical,
          {
            {
              layout = wibox.layout.align.horizontal,
              expand = "none",
              nil,
              icon,
              nil,
            },
            {
              layout = wibox.layout.fixed.vertical,
              spacing = dpi(5),
              {
                layout = wibox.layout.align.horizontal,
                expand = "none",
                osd_header,
                nil,
                osd_value,
              },
              slider_osd,
            },
            spacing = dpi(10),
            layout = wibox.layout.fixed.vertical,
          },
        },
        left = dpi(24),
        right = dpi(24),
        widget = wibox.container.margin,
      },
      bg = beautiful.background,
      shape = gears.shape.rounded_rect,
      widget = wibox.container.background(),
    })

    -- Reset timer on mouse hover
    volume_osd:connect_signal("mouse::enter", function()
      rerun()
    end)
  end
end
