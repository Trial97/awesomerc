local awful             = require('awful')
local wibox             = require('wibox')
local gears             = require('gears')
local beautiful         = require('beautiful')
local click_container   = require('widgets.clickable-container')

local dpi               = beautiful.xresources.apply_dpi

return function(text, icon, toggleAction)
    local action_name = wibox.widget {
        text    = text,
        font    = 'Inter Bold 10',
        align   = 'left',
        widget  = wibox.widget.textbox
    }
    local action_status = wibox.widget {
        text    = 'Off',
        font    = 'Inter Regular 10',
        align   = 'left',
        widget  = wibox.widget.textbox
    }
    local action_info = wibox.widget {
        layout  = wibox.layout.fixed.vertical,
        action_name,
        action_status
    }
    local button_widget = wibox.widget {
        {
            id     = 'icon',
            image  = icon,
            widget = wibox.widget.imagebox,
            resize = true
        },
        layout = wibox.layout.align.horizontal
    }
    local widget_button = wibox.widget {
        {
            {
                button_widget,
                margins       = dpi(15),
                forced_height = dpi(48),
                forced_width  = dpi(48),
                widget        = wibox.container.margin
            },
            widget = click_container
        },
        bg      = beautiful.groups_bg,
        shape   = gears.shape.circle,
        widget  = wibox.container.background
    }

    widget_button:buttons({awful.button({}, 1, nil, toggleAction)})
    action_info:buttons(  {awful.button({}, 1, nil, toggleAction)})

    local action_widget = wibox.widget {
        layout  = wibox.layout.fixed.horizontal,    
        spacing = dpi(10),
        widget_button,
        {
            layout = wibox.layout.align.vertical,
            expand = 'none',
            nil,
            action_info,
            nil
        }
    }

    function action_widget:updateButton(text, bg, icon)
        action_status:set_text(text)
        widget_button.bg = bg
        button_widget.icon:set_image(icon)
    end

    return action_widget
end