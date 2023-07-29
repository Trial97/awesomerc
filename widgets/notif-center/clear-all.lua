local awful             = require('awful')
local wibox             = require('wibox')
local gears             = require('gears')
local beautiful         = require('beautiful')
local click_container   = require('widgets.clickable-container')
local notifbox_core     = require('widgets.notif-center.build-notifbox')

local dpi             = beautiful.xresources.apply_dpi
local widget_icon_dir = beautiful.get().icons .. 'widgets/notif-center/'

local clear_all_imagebox = wibox.widget {
    {
        image         = widget_icon_dir .. 'clear_all.svg',
        resize        = true,
        forced_height = dpi(17),
        forced_width  = dpi(17),
        widget        = wibox.widget.imagebox,
    },
    layout = wibox.layout.fixed.horizontal
}

local clear_all_button = wibox.widget {
    {
        clear_all_imagebox,
        margins = dpi(5),
        widget  = wibox.container.margin
    },
    widget = click_container
}

clear_all_button:buttons({awful.button({}, 1, nil, notifbox_core.reset_notifbox_layout)})

return wibox.widget {
    nil,
    {
        clear_all_button,
        bg     = beautiful.transparent,
        shape  = gears.shape.circle,
        widget = wibox.container.background
    },
    nil,
    expand = 'none',
    layout = wibox.layout.align.vertical
}