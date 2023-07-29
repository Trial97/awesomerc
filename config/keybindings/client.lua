local awful = require('awful')
local dpi   = require('beautiful').xresources.apply_dpi
local keys  = require('config.keys')

local function buttons()
    local modkey = keys.modkey
    awful.mouse.append_client_mousebindings({
        awful.button({}, 1, function(c)
            c:activate { context = 'mouse_click' }
            awesome.emit_signal('module::menu:toggle', false)
        end),
        awful.button({ modkey }, 1, function(c) c:activate { context = 'mouse_click', action = 'mouse_move' } end),
        awful.button({ modkey }, 3, function(c) c:activate { context = 'mouse_click', action = 'mouse_resize' } end),
        awful.button({ modkey }, 4, function() awful.layout.inc(1) end),
        awful.button({ modkey }, 5, function() awful.layout.inc(-1) end)
    })
end

local function keybindings()
    local modkey = keys.modkey
    awful.keyboard.append_client_keybindings({
        -- try: x,q,c
        awful.key({ modkey, }, 'q', function(c) c:kill() end,
            { description = 'close', group = 'client' }),
        awful.key({ modkey, }, 'n', function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end, { description = 'minimize', group = 'client' }),
        awful.key({ modkey, }, 'm', function(c)
            c.maximized = not c.maximized
            c:raise()
        end, { description = '(un)maximize', group = 'client' }),
        awful.key({ modkey, 'Control' }, 'm', function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end, { description = '(un)maximize vertically', group = 'client' }),
        awful.key({ modkey, 'Shift' }, 'm', function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end, { description = '(un)maximize horizontally', group = 'client' }),


        awful.key({ modkey, 'Shift' }, 'f', function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end, { description = 'toggle fullscreen', group = 'client' }),
        awful.key({ modkey, 'Control', }, 'f', awful.client.floating.toggle,
            { description = 'toggle floating', group = 'client' }),
        awful.key({ modkey, 'Control' }, 'Return', function(c) c:swap(awful.client.getmaster()) end,
            { description = 'move to master', group = 'client' }),
        awful.key({ modkey, }, 'o', function(c) c:move_to_screen() end,
            { description = 'move to screen', group = 'client' }),
        awful.key({ modkey, }, 't', function(c) c.ontop = not c.ontop end,
            { description = 'toggle keep on top', group = 'client' }),

        awful.key({ modkey, }, 'd', function()
            awful.client.focus.byidx(1)
        end, { description = 'focus next by index', group = 'client' }),
        awful.key({ modkey, }, 'a', function()
            awful.client.focus.byidx(-1)
        end, { description = 'focus previous by index', group = 'client' }),
        awful.key({ modkey, 'Shift' }, 'd', function()
            awful.client.swap.byidx(1)
        end, { description = 'swap with next client by index', group = 'client' }),
        awful.key({ modkey, 'Shift' }, 'a', function()
            awful.client.swap.byidx(-1)
        end, { description = 'swap with next client by index', group = 'client' }),
        awful.key({ modkey, }, 'u', awful.client.urgent.jumpto,
            { description = 'jump to urgent client', group = 'client' }),
        awful.key({ modkey, }, 'Tab', function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end, { description = 'go back', group = 'client' }),

        awful.key({ modkey }, 'Up', function(c)
            c:relative_move(0, dpi(-10), 0, 0)
        end, { description = 'move floating client up by 10 px', group = 'client' }),
        awful.key({ modkey }, 'Down', function(c)
            c:relative_move(0, dpi(10), 0, 0)
        end, { description = 'move floating client down by 10 px', group = 'client' }),
        awful.key({ modkey }, 'Left', function(c)
            c:relative_move(dpi(-10), 0, 0, 0)
        end, { description = 'move floating client to the left by 10 px', group = 'client' }),
        awful.key({ modkey }, 'Right', function(c)
            c:relative_move(dpi(10), 0, 0, 0)
        end, { description = 'move floating client to the right by 10 px', group = 'client' }),
        awful.key({ modkey, 'Shift' }, 'Up', function(c)
            c:relative_move(0, dpi(-10), 0, dpi(10))
        end, { description = 'increase floating client size vertically by 10 px up', group = 'client' }),
        awful.key({ modkey, 'Shift' }, 'Down', function(c)
            c:relative_move(0, 0, 0, dpi(10))
        end, { description = 'increase floating client size vertically by 10 px down', group = 'client' }),
        awful.key({ modkey, 'Shift' }, 'Left', function(c)
            c:relative_move(dpi(-10), 0, dpi(10), 0)
        end, { description = 'increase floating client size horizontally by 10 px left', group = 'client' }),
        awful.key({ modkey, 'Shift' }, 'Right', function(c)
            c:relative_move(0, 0, dpi(10), 0)
        end, { description = 'increase floating client size horizontally by 10 px right', group = 'client' }),
        awful.key({ modkey, 'Control' }, 'Up', function(c)
            if c.height > 10 then
                c:relative_move(0, 0, 0, dpi(-10))
            end
        end, { description = 'decrease floating client size vertically by 10 px up', group = 'client' }),
        awful.key({ modkey, 'Control' }, 'Down', function(c)
            local c_height = c.height
            c:relative_move(0, 0, 0, dpi(-10))
            if c.height ~= c_height and c.height > 10 then
                c:relative_move(0, dpi(10), 0, 0)
            end
        end, { description = 'decrease floating client size vertically by 10 px down', group = 'client' }),
        awful.key({ modkey, 'Control' }, 'Left', function(c)
            if c.width > 10 then
                c:relative_move(0, 0, dpi(-10), 0)
            end
        end, { description = 'decrease floating client size horizontally by 10 px left', group = 'client' }),
        awful.key({ modkey, 'Control' }, 'Right', function(c)
            local c_width = c.width
            c:relative_move(0, 0, dpi(-10), 0)
            if c.width ~= c_width and c.width > 10 then
                c:relative_move(dpi(10), 0, 0, 0)
            end
        end, { description = 'decrease floating client size horizontally by 10 px right', group = 'client' }),
        awful.key({ modkey, 'Control' }, 't', awful.titlebar.toggle,
            { description = 'toggle titlebar', group = 'client' }),
    })
end

return function()
    client.connect_signal('request::default_mousebindings', function() buttons() end)
    client.connect_signal('request::default_keybindings', function() keybindings() end)
end
