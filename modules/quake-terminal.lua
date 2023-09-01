local awful = require("awful")
local ruled = require("ruled")
local beautiful = require("beautiful")
local lain = require("extra.lain")
local apps = require("utils.constats")

local quake_properties = function()
  return {
    skip_decoration = true,
    titlebars_enabled = false,
    switch_to_tags = false,
    opacity = 0.95,
    floating = true,
    ontop = true,
    above = true,
    sticky = true,
    hidden = true,
    maximized_horizontal = true,
    skip_center = true,
    round_corners = false,
    placement = awful.placement.top,
    shape = beautiful.client_shape_rectangle,
    skip_taskbar = true,
    requests_no_titlebar = true,
  }
end

ruled.client.connect_signal("request::rules", function()
  ruled.client.append_rule({
    id = "quake_terminal",
    rule_any = { instance = { "QuakeDD" } },
    properties = quake_properties(),
  })
end)

return lain.util.quake({
  app = apps.terminal,
  argname = "--name %s",
  followtag = true,
  settings = function(c)
    ruled.client.execute(c, quake_properties())
  end,
})
