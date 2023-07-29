local wibox     = require('wibox')
local awful     = require('awful')
local gears     = require('gears')
local beautiful = require('beautiful')
local utils     = require('utils')

local dpi = beautiful.xresources.apply_dpi

local builder       = require('widgets.notif-center.build-notifbox.notifbox-ui-elements')
local notifbox_core = require('widgets.notif-center.build-notifbox')

local notifbox_layout       = notifbox_core.notifbox_layout
local reset_notifbox_layout = notifbox_core.reset_notifbox_layout

return function(notif, icon, title, message, app, bgcolor)
    local time_of_pop     = utils.current_time()
    local exact_time      = utils.current_time('%I:%M %p')
    local exact_date_time = utils.current_time('%b %d, %I:%M %p')  

    local notifbox_timepop =  wibox.widget {
        id      = 'time_pop',
        markup  = nil,
        font    = 'Inter Regular 10',
        align   = 'left',
        valign  = 'center',
        visible = true,
        widget  = wibox.widget.textbox
    }

    local notifbox_dismiss = builder.notifbox_dismiss()

    local time_of_popup = gears.timer {
        timeout   = 60,
        call_now  = true,
        autostart = true,
        callback  = function()
            local time_difference = utils.parse_to_seconds(utils.current_time()) - utils.parse_to_seconds(time_of_pop)
            time_difference = tonumber(time_difference)

            if time_difference < 60 then
                notifbox_timepop:set_markup('now')
            elseif time_difference >= 60 and time_difference < 3600 then
                local time_in_minutes = math.floor(time_difference / 60)
                notifbox_timepop:set_markup(time_in_minutes .. 'm ago')
            elseif time_difference >= 3600 and time_difference < 86400 then
                notifbox_timepop:set_markup(exact_time)
            elseif time_difference >= 86400 then
                notifbox_timepop:set_markup(exact_date_time)
                return false
            end
            collectgarbage('collect')
        end
    }

    local notifbox_template =  wibox.widget {
        id     = 'notifbox_template',
        expand = 'none',
        {
            {
                layout  = wibox.layout.fixed.vertical,
                spacing = dpi(5),
                {
                    expand = 'none',
                    layout = wibox.layout.align.horizontal,
                    {
                        layout  = wibox.layout.fixed.horizontal,
                        spacing = dpi(5),
                        builder.notifbox_icon(icon),
                        builder.notifbox_appname(app),
                    },
                    nil,
                    {
                        notifbox_timepop,
                        notifbox_dismiss,
                        layout = wibox.layout.fixed.horizontal
                    }
                },
                {
                    layout  = wibox.layout.fixed.vertical,
                    spacing = dpi(5),
                    {
                        builder.notifbox_title(title),
                        builder.notifbox_message(message),
                        layout = wibox.layout.fixed.vertical
                    },
                    builder.notifbox_actions(notif),
                },

            },
            margins = dpi(10),
            widget  = wibox.container.margin
        },
        bg     = bgcolor,
        shape  = function(cr, width, height)
            gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, beautiful.groups_radius)
        end,
        widget = wibox.container.background,
    }

    -- Put the generated template to a container
    local notifbox = wibox.widget {
        notifbox_template,
        shape  = function(cr, width, height)
            gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, beautiful.groups_radius)
        end,
        widget = wibox.container.background
    }

    -- Delete notifbox on LMB
    notifbox:buttons({awful.button({}, 1, function()
        if #notifbox_layout.children == 1 then
            reset_notifbox_layout()
        else
            notifbox_layout:remove_widgets(notifbox, true)
        end
        collectgarbage('collect')
    end)})

    -- Add hover, and mouse leave events
    notifbox_template:connect_signal('mouse::enter', function() 
        notifbox.bg = beautiful.groups_bg
        notifbox_timepop.visible = false
        notifbox_dismiss.visible = true
    end)

    notifbox_template:connect_signal('mouse::leave', function() 
        notifbox.bg = beautiful.tranparent
        notifbox_timepop.visible = true
        notifbox_dismiss.visible = false
    end)

    collectgarbage('collect')
    
    return notifbox
end
