local wibox         = require('wibox')
local awful         = require('awful')
local beautiful     = require('beautiful')
local task_list     = require('widgets.task-list')
local tag_list      = require('widgets.tag-list')
local clock_widget  = require('widgets.clock')
local layoutbox     = require('widgets.layoutbox')
local battery       = require('evil.battery')
local controlToggle = require('widgets.control-toggle')
local apps          = require('utils.constats')
local keys          = require('config.keys')

local dpi           = beautiful.xresources.apply_dpi

return function(s)
    local panel = awful.wibar {
        position = "top",
        visible = true,
        ontop   = true,
        screen  = s,
        type    = 'dock',
        height  = dpi(28),
        width   = s.geometry.width,
        x       = s.geometry.x,
        y       = s.geometry.y,
        stretch = false,
        bg      = beautiful.background,
        fg      = beautiful.fg_normal
    }

    panel:connect_signal('mouse::enter', function()
        local w = mouse.current_wibox
        if w then w.cursor = 'left_ptr' end
    end)

    panel.systray  = wibox.widget {
        visible    = true,
        base_size  = dpi(20),
        horizontal = true,
        screen     = 'primary',
        widget     = wibox.widget.systray
    }

    panel.clock         = clock_widget(s, '%a %d %b %H:%M:%S')
    panel.layout_box    = layoutbox(s)
    panel.battery       = battery(apps.power_manager)
    s.control_toggle    = controlToggle(s)
    panel:setup{
        expand  = 'none',
        layout  = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal, 
            tag_list(s, keys.modkey),
            task_list(s)
        },
        panel.clock.clock_widget,
        {
            layout  = wibox.layout.fixed.horizontal,
            spacing = dpi(5),
            {
                panel.systray,
                margins = dpi(5), 
                widget  = wibox.container.margin
            },
            panel.battery,
            s.control_toggle,
            panel.layout_box
        }
    }

    return panel
end

