local wibox             = require('wibox')
local awful             = require('awful')
local beautiful         = require('beautiful')
local click_container   = require('widgets.clickable-container')

local dpi               = beautiful.xresources.apply_dpi

return function(s)
    local layoutbox = wibox.widget {
        {
            awful.widget.layoutbox(s),
            margins = dpi(7),
            widget  = wibox.container.margin
        },
        widget = click_container
    }
    layoutbox:buttons({
        awful.button({}, 1, function() awful.layout.inc( 1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc( 1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)
    })
    return layoutbox
end