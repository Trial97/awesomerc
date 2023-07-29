local wibox     = require('wibox')
local beautiful = require('beautiful')

return function(widget)
    local container = wibox.widget {
        widget,
        widget = wibox.container.background
    }

    -- Old and new widget
    local old_cursor, old_wibox

    -- Mouse hovers on the widget
    container:connect_signal( 'mouse::enter',      function()
        container.bg = beautiful.groups_bg
        -- Hm, no idea how to get the wibox from this signal's arguments...
        local w = mouse.current_wibox
        if w then
            old_cursor, old_wibox = w.cursor, w
            w.cursor = 'hand2'
        end
    end)

    -- Mouse leaves the widget
    container:connect_signal( 'mouse::leave',      function()
        container.bg = beautiful.leave_event
        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end
    end)

    container:connect_signal( 'button::press',      function()
        container.bg = beautiful.press_event
    end)
    container:connect_signal( 'button::release', function()
        container.bg = beautiful.release_event
    end)
    return container
end
