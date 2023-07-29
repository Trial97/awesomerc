local wibox             = require('wibox')
local beautiful         = require('beautiful')
local naughty           = require('naughty')
local gears             = require('gears')
local click_container   = require('widgets.clickable-container')

local dpi             = beautiful.xresources.apply_dpi
local widget_icon_dir = beautiful.get().icons .. 'widgets/notif-center/'

local ui_noti_builder = {}

-- Notification icon container
ui_noti_builder.notifbox_icon = function(ico_image)
    local noti_icon = wibox.widget {
        {
            id            = 'icon',
            resize        = true,
            forced_height = dpi(25),
            forced_width  = dpi(25),
            widget        = wibox.widget.imagebox
        },
        layout = wibox.layout.fixed.horizontal
    }
    noti_icon.icon:set_image(ico_image)
    return noti_icon
end

-- Notification title container
ui_noti_builder.notifbox_title = function(title)
    return wibox.widget {
        markup = title,
        font   = 'Inter Bold 12',
        align  = 'left',
        valign = 'center',
        widget = wibox.widget.textbox
    }
end

-- Notification message container
ui_noti_builder.notifbox_message = function(msg)
    return wibox.widget {
        markup = msg,
        font   = 'Inter Regular 11',
        align  = 'left',
        valign = 'center',
        widget = wibox.widget.textbox
    }
end

-- Notification app name container
ui_noti_builder.notifbox_appname = function(app)
    return wibox.widget {
        markup = app,
        font   = 'Inter Bold 12',
        align  = 'left',
        valign = 'center',
        widget = wibox.widget.textbox
    }
end

-- Notification actions container
ui_noti_builder.notifbox_actions = function(n)
    return wibox.widget {
        notification = n,
        base_layout  = wibox.widget {
            spacing  = dpi(0),
            layout   = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'text_role',
                            font   = 'Inter Regular 10',
                            widget = wibox.widget.textbox
                        },
                        widget = wibox.container.place
                    },
                    widget = click_container
                },
                bg                 = beautiful.groups_bg,
                shape              = gears.shape.rounded_rect,
                forced_height      = 30,
                widget             = wibox.container.background
            },
            margins = 4,
            widget  = wibox.container.margin
        },
        style = { underline_normal = false, underline_selected = true },
        widget = naughty.list.actions,
    }
end


-- Notification dismiss button
ui_noti_builder.notifbox_dismiss = function()
    local dismiss_imagebox = wibox.widget {
        {
            id            = 'dismiss_icon',
            image         = widget_icon_dir .. 'delete.svg',
            resize        = true,
            forced_height = dpi(5),
            widget        = wibox.widget.imagebox
        },
        layout = wibox.layout.fixed.horizontal
    }

    local dismiss_button = wibox.widget {
        {
            dismiss_imagebox,
            margins = dpi(5),
            widget  = wibox.container.margin
        },
        widget = click_container
    }

    return wibox.widget {
        dismiss_button,
        visible = false,
        bg      = beautiful.groups_title_bg,
        shape   = gears.shape.circle,
        widget  = wibox.container.background
    }
end


return ui_noti_builder