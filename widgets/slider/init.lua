local wibox             = require('wibox')
local gears             = require('gears')
local awful             = require('awful')
local beautiful         = require('beautiful')
local click_container   = require('widgets.clickable-container')

local dpi               = beautiful.xresources.apply_dpi

return function(text, icon, update_value)
    local action_name = wibox.widget {
        text    = text,
        font    = 'Inter Bold 10',
        align   = 'left',
        widget  = wibox.widget.textbox
    }

    local icon = wibox.widget {
        layout = wibox.layout.align.vertical,
        expand = 'none',
        nil,
        {
            image  = icon,
            resize = true,
            widget = wibox.widget.imagebox
        },
        nil
    }

    local action_level = wibox.widget {
        {
            {
                icon,
                margins = dpi(5),
                widget  = wibox.container.margin
            },
            widget = click_container,
        },
        bg      = beautiful.groups_bg,
        shape   = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
        end,
        widget  = wibox.container.background
    }

    local slider = wibox.widget {
        nil,
        {
            id                  = 'slider',
            bar_shape           = gears.shape.rounded_rect,
            bar_height          = dpi(24),
            bar_color           = '#ffffff20',
            bar_active_color    = '#f2f2f2EE',
            handle_color        = '#ffffff',
            handle_shape        = gears.shape.circle,
            handle_width        = dpi(24),
            handle_border_color = '#00000012',
            handle_border_width = dpi(1),
            maximum             = 100,
            widget              = wibox.widget.slider
        },
        nil,
        expand          = 'none',
        forced_height   = dpi(24),
        layout          = wibox.layout.align.vertical
    }

    local slider = slider.slider


    slider:buttons({
        awful.button({}, 4, nil, function()
            if slider:get_value() > 100 then
                slider:set_value(100)
                return
            end
            slider:set_value(slider:get_value() + 5)
        end),
        awful.button({}, 5, nil, function()
            if slider:get_value() < 0 then
                slider:set_value(0)
                return
            end
            slider:set_value(slider:get_value() - 5)
        end)
    })




    local action_jump = function()
        local sli_value = slider:get_value()
        local new_value = 0

        if sli_value >= 0 and sli_value < 50 then
            new_value = 50
        elseif sli_value >= 50 and sli_value < 100 then
            new_value = 100
        else
            new_value = 0
        end
        slider:set_value(new_value)
    end

    action_level:buttons({awful.button({}, 1, nil, action_jump)})



    local widget = wibox.widget {
        layout          = wibox.layout.fixed.vertical,
        forced_height   = dpi(48),
        spacing         = dpi(5),
        action_name,
        {
            layout  = wibox.layout.fixed.horizontal,
            spacing = dpi(5),
            {
                layout = wibox.layout.align.vertical,
                expand = 'none',
                nil,
                {
                    layout          = wibox.layout.fixed.horizontal,
                    forced_height   = dpi(24),
                    forced_width    = dpi(24),
                    action_level
                },
                nil
            },
            slider
        }
    }
    local changed_outside = false
    function widget:set_value(value)
        changed_outside = true
        slider:set_value(value)
    end

    slider:connect_signal('property::value', function()
        if not changed_outside then update_value(slider:get_value()) end
        changed_outside = false
    end)

    function widget:get_value()
        return slider:get_value()
    end
    return widget
end