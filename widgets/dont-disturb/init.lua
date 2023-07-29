local awful     = require('awful')
local beautiful = require('beautiful')
local toggle    = require('widgets.toggle')

local widget_icon_dir = beautiful.get().icons .. 'widgets/dont-disturb/'
_G.dont_disturb_state = false
local offIcon         = widget_icon_dir .. 'notify.svg'
local onIcon          = widget_icon_dir .. 'dont-disturb.svg'

local widget = toggle('Don\'t Disturb', offIcon, function()
    awesome.emit_signal('widgets::dont-disturb', false)
end)

local function update_widget()
    if _G.dont_disturb_state then
        widget:updateButton('On', beautiful.system_cyan_dark, onIcon)
    else
        widget:updateButton('Off', beautiful.groups_bg, offIcon)
    end
end

awesome.connect_signal('widgets::dont-disturb', function()
    _G.dont_disturb_state = not _G.dont_disturb_state
    update_widget()
end)

return widget