local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local icons = require('themes.icons')
local toggle = require('widgets.toggle')
local gfs = gears.filesystem

local widget_icon_dir = beautiful.get().icons .. 'widgets/blur/'
local config = '$HOME/.config/picom/picom.conf'

local state = false
local offIcon = widget_icon_dir .. 'effects-off.svg'
local onIcon = icons.effects

local conf_dir = gfs.get_configuration_dir() 

local function createPicomCfg()
    if not gfs.file_readable(config) then
        awful.spawn.with_shell("mkdir -p $(dirname "..config..");cp "..conf_dir.."widgets/blur-toggle/picom.conf "..config)
    end
end

local function toggle_blur()
  createPicomCfg()
  local script = [[bash -c "
    # Check picom if it's not running then start it
    if [ -z $(pgrep picom) ]; then
        picom -b --dbus --config ]] .. config .. [[;fi
]]
  if state then
    script = script .. [[sed -i -e 's/method = \"none\"/method = \"dual_kawase\"/g' \"]] .. config .. [[\""]]
  else
    script = script .. [[ sed -i -e 's/method = \"dual_kawase\"/method = \"none\"/g' \"]] .. config .. [[\""]]
  end
  awful.spawn.with_shell(script)
end

local widget = toggle('Blur Effects', offIcon, function()
  awesome.emit_signal('widgets::blur', false)
end)

local function update_widget()
  if state then
    widget:updateButton('On', beautiful.system_magenta_dark, onIcon)
  else
    widget:updateButton('Off', beautiful.groups_bg, offIcon)
  end
end

awesome.connect_signal('widgets::blur', function()
  state = not state
  toggle_blur()
  update_widget()
end)

awful.spawn.easy_async_with_shell([[bash -c "
    grep -F 'method = \"none\";' ]] .. config .. [[ | tr -d '[\"\;\=\ ]'"]], function(stdout, stderr)
  state = not stdout:match('methodnone')
  update_widget()
end)
return widget
