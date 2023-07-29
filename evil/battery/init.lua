local awful             = require('awful')
local wibox             = require('wibox')
local gears             = require('gears')
local naughty           = require('naughty')
local beautiful         = require('beautiful')
local click_container   = require('widgets.clickable-container')

local dpi               = beautiful.xresources.apply_dpi
local watch             = awful.widget.watch

local widget_icon_dir   = beautiful.get().icons .. 'widgets/battery/'
local notify_critcal    = true
local last_check        = os.time()
local battery_button    = nil
local battery_tooltip   = nil

local battery_imagebox = wibox.widget {
    nil,
    {
        id      = 'icon',
        image   = widget_icon_dir .. 'battery' .. '.svg',
        widget  = wibox.widget.imagebox,
        resize  = true
    },
    nil,
    expand = 'none',
    layout = wibox.layout.align.vertical
}

local battery_percentage_text = wibox.widget {
    id      = 'percent_text',
    text    = '100%',
    font    = 'Inter Bold 11',
    align   = 'center',
    valign  = 'center',
    visible = false,
    widget  = wibox.widget.textbox
}

local battery_widget = wibox.widget {
    layout  = wibox.layout.fixed.horizontal,
    spacing = dpi(0),
    battery_imagebox,
    battery_percentage_text
}


local  function show_battery_warning()
    naughty.notification({
        icon        = widget_icon_dir .. 'battery-alert.svg',
        app_name    = 'System notification',
        title       = 'Battery is dying!',
        message     = 'Hey, I think we have a problem here. Save your work before reaching the oblivion.',
        urgency     = 'critical'
    })
end

local function get_battery_info(battery_tooltip)
    awful.spawn.easy_async_with_shell('upower -i $(upower -e | grep BAT)', function(stdout)
        if stdout == nil or stdout == '' then
            battery_tooltip:set_text('No battery detected!')
            return
        end
        -- Remove new line from the last line
        battery_tooltip:set_text(stdout:sub(1, -2))
    end)
end

local function get_icon(battery_percentage, status)
    local icon_name = 'battery'
    if (status == 'fully-charged' or status == 'charging') and
        battery_percentage == 100 then -- Fully charged
        icon_name = icon_name .. '-' .. 'fully-charged'
    elseif (battery_percentage > 0 and battery_percentage < 10) and 
        status == 'discharging' then -- Critical level warning message
        icon_name = icon_name .. '-' .. 'alert-red'
    elseif (status == 'unknown') then
        icon_name = icon_name .. '-' .. 'unknown'
    elseif battery_percentage > 0 and battery_percentage < 20 then -- Discharging
        icon_name = icon_name .. '-' .. status .. '-' .. '10'
    elseif battery_percentage >= 20 and battery_percentage < 30 then
        icon_name = icon_name .. '-' .. status .. '-' .. '20'
    elseif battery_percentage >= 30 and battery_percentage < 50 then
        icon_name = icon_name .. '-' .. status .. '-' .. '30'
    elseif battery_percentage >= 50 and battery_percentage < 60 then
        icon_name = icon_name .. '-' .. status .. '-' .. '50'
    elseif battery_percentage >= 60 and battery_percentage < 80 then
        icon_name = icon_name .. '-' .. status .. '-' .. '60'
    elseif battery_percentage >= 80 and battery_percentage < 90 then
        icon_name = icon_name .. '-' .. status .. '-' .. '80'
    elseif battery_percentage >= 90 and battery_percentage < 100 then
        icon_name = icon_name .. '-' .. status .. '-' .. '90'
    end
    return icon_name
end

local function update_battery(status)
    awful.spawn.easy_async_with_shell(
        [[ sh -c "upower -i $(upower -e | grep BAT) | grep percentage | awk '{print \$2}' | tr -d '\n%'" ]],
        function(stdout)
            local battery_percentage = tonumber(stdout)
            -- Stop if null
            if not battery_percentage then return end

            battery_widget.spacing          = dpi(5)
            battery_percentage_text.visible = true
            battery_percentage_text:set_text(battery_percentage .. '%')

            local icon_name = get_icon(battery_percentage, status)
            if icon_name == 'battery-alert-red' then
                local now = os.time()
                if (os.difftime(now, last_check) > 300 or
                    notify_critcal) then
                    last_check      = now
                    notify_critcal  = false
                    show_battery_warning()
                end
            elseif not notify_critcal then
                    notify_critcal = true
            end
            battery_imagebox.icon:set_image( gears.surface.load_uncached(
                widget_icon_dir .. icon_name .. '.svg'))
        end)
end

-- Watch status if charging, discharging, fully-charged
watch([[sh -c "
upower -i $(upower -e | grep BAT) | grep state | awk '{print \$2}' | tr -d '\n'
"]], 5, function(_, stdout)
    local status = stdout:gsub('%\n', '')
    if not battery_button then
        return
    end
    -- If no output or no battery detected
    if status == nil or status == '' then
        battery_widget.spacing = dpi(0)
        battery_percentage_text.visible = false
        battery_tooltip:set_text('No battery detected!')
        battery_imagebox.icon:set_image(
            gears.surface.load_uncached(widget_icon_dir .. 'battery-unknown' ..
                                            '.svg'))
        return
    end
    update_battery(status)
end)

return function(power_manager_cmd)
    if not battery_button then
        battery_button = wibox.widget {
            {
                battery_widget,
                margins = dpi(7),
                widget  = wibox.container.margin
            },
            widget = click_container
        }
        
        battery_button:buttons({awful.button({}, 1, nil, function()
            awful.spawn(power_manager_cmd, false)
        end)})

        battery_tooltip = awful.tooltip {
            objects             = { battery_button },
            text                = 'None',
            -- mode                = 'outside',
            align               = 'right',
            margin_leftright    = dpi(8),
            margin_topbottom    = dpi(8),
            preferred_positions = {'right', 'left', 'top', 'bottom'}
        }

        get_battery_info(battery_tooltip)
        battery_widget:connect_signal('mouse::enter', function() get_battery_info(battery_tooltip) end)
    end

    return battery_button
end

