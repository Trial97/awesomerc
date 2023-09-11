local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local toggle = require('widgets.toggle')

local config_dir = gears.filesystem.get_configuration_dir()
local widget_dir = config_dir .. 'widgets/airplane-mode/'
local widget_icon_dir = beautiful.get().icons .. 'widgets/airplane-mode/'

local state = false
local offIcon = widget_icon_dir .. 'airplane-mode-off.svg'
local onIcon = widget_icon_dir .. 'airplane-mode.svg'

local ap_off_cmd = [[rfkill unblock wlan
    # Create an AwesomeWM Notification
    awesome-client "
    naughty = require('naughty')
    naughty.notification({
        app_name = 'Network Manager',
        title = '<b>Airplane mode disabled!</b>',
        message = 'Initializing network devices',
        icon = ']] .. offIcon .. [['
    })
    "
    ]] .. 'echo false > ' .. widget_dir .. 'airplane_mode' .. [[
]]

local ap_on_cmd = [[rfkill block wlan
    # Create an AwesomeWM Notification
    awesome-client "
    naughty = require('naughty')
    naughty.notification({
        app_name = 'Network Manager',
        title = '<b>Airplane mode enabled!</b>',
        message = 'Disabling radio devices',
        icon = ']] .. onIcon .. [['
    })
    "
    ]] .. 'echo true > ' .. widget_dir .. 'airplane_mode' .. [[
]]

local widget = toggle('Airplane Mode', offIcon, function()
  awesome.emit_signal('widgets::airplane-mode', false)
end)

local function update_widget()
  if state then
    widget:updateButton('On', beautiful.accent, onIcon)
  else
    widget:updateButton('Off', beautiful.groups_bg, offIcon)
  end
end

awesome.connect_signal('widgets::airplane-mode', function()
  local cmd = ap_on_cmd
  if state then
    cmd = ap_off_cmd
  end
  awful.spawn.easy_async_with_shell(cmd, function()
    state = not state
    update_widget()
  end)
end)

local check_airplane_mode_state = function()
  awful.spawn.easy_async_with_shell('cat ' .. widget_dir .. 'airplane_mode', function(stdout)
    if stdout:match('true') then
      state = true
    elseif stdout:match('false') then
      state = false
    else
      state = false
      awful.spawn.easy_async_with_shell('echo "false" > ' .. widget_dir .. 'airplane_mode', function() end)
    end
    update_widget()
  end)
end

check_airplane_mode_state()
gears.timer({
  timeout = 5,
  autostart = true,
  callback = check_airplane_mode_state,
})

return widget
