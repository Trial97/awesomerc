local wibox             = require('wibox')
local awful             = require('awful')
local gears             = require('gears')
local beautiful         = require('beautiful')
local click_container   = require('widgets.clickable-container')
local utils             = require('utils')

local dpi               = beautiful.xresources.apply_dpi
local clock_widget      = nil

return function(s, format)
    if not clock_widget then
        local clock_format  = format or '%H:%M'
        clock_widget        = wibox.widget.textclock(
                                '<span font="Inter Bold 11">' ..
                                clock_format ..
                                '</span>', 1)
    end

    local clockw = wibox.widget {
        {
            clock_widget,
            margins = dpi(7),
            widget  = wibox.container.margin
        },
        widget = click_container
    }

    local clock_tooltip = awful.tooltip {
        objects                 = { clockw},
        -- mode                    = 'outside',
        delay_show              = 1,
        preferred_positions     = { 'right', 'left', 'top', 'bottom'},
        preferred_alignments    = { 'middle', 'front', 'back'},
        margin_leftright        = dpi(8),
        margin_topbottom        = dpi(8),
        timer_function          = function()
            return 'Today is the ' .. '<b>' ..
                utils.get_date_ordinal(os.date('%d')) ..
                ' of ' .. os.date('%B') .. '</b>.\n'  ..
                'And it\'s fucking ' .. os.date('%A')
        end
    }

    clockw:connect_signal( 'button::press',
                           function(self, lx, ly, button)
        -- Hide the tooltip when you press the clock widget
        if clock_tooltip.visible and button == 1 then
            clock_tooltip.visible = false
        end
    end)

    local month_calendar  = awful.widget.calendar_popup.month({
        start_sunday  = false,
        spacing       = dpi(5),
        font          = 'Inter Regular 10',
        long_weekdays = true,
        margin        = dpi(5),
        screen        = s,
        style_month   = {
            border_width = dpi(0),
            bg_color     = beautiful.background,
            padding      = dpi(20),
            shape        = function(cr, width, height)
                gears.shape.partially_rounded_rect(cr, width, height, true,
                                                   true, true, true,
                                                   beautiful.groups_radius)
            end
        },
        style_header  = { border_width = 0, bg_color = beautiful.transparent },
        style_weekday = { border_width = 0, bg_color = beautiful.transparent },
        style_normal  = { border_width = 0, bg_color = beautiful.transparent },
        style_focus   = {
            border_width = dpi(0),
            border_color = beautiful.fg_normal,
            bg_color     = beautiful.accent,
            shape        = function(cr, width, height)
                gears.shape.partially_rounded_rect(cr, width, height, true,
                                                   true, true, true, dpi(4))
            end
        }
    })
    month_calendar:attach(clockw, 'tc',
                        { on_pressed = true, on_hover = false })

    return {
        clock_widget   = clockw,
        clock_tooltip  = clock_tooltip,
        month_calendar = month_calendar,
    }
end

