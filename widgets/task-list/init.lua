local awful = require("awful")
local wibox = require("wibox")

local tasklist_buttons = {
  awful.button({}, 1, function(c)
    c:activate({
      context = "tasklist",
      action = "toggle_minimization",
    })
  end),
  awful.button({ "Control" }, 2, function(c)
    c:kill()
  end),
  awful.button({}, 3, function()
    awful.menu.client_list({
      theme = { width = 250 },
    })
  end),
  awful.button({}, 4, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
  end),
}

return function(s)
  return awful.widget.tasklist({
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
    -- update_function    = list_update,
    layout = {
      spacing_widget = {
        {
          forced_width = 5,
          thickness = 1,
          color = "#777777",
          widget = wibox.widget.separator,
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place,
      },
      spacing = 1,
      layout = wibox.layout.flex.horizontal,
    },
    -- Notice that there is *NO* wibox.wibox prefix, it is a template,
    -- not a widget instance.
    widget_template = {
      {
        {
          {
            awful.widget.clienticon,
            margins = 5,
            widget = wibox.container.margin,
          },
          {
            id = "text_role",
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.horizontal,
        },
        left = 10,
        right = 10,
        widget = wibox.container.margin,
      },
      id = "background_role",
      widget = wibox.container.background,
    },
  })
end
