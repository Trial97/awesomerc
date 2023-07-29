-- MODULE AUTO-START

local awful = require('awful')
local gears = require('gears')
local gfs   = gears.filesystem

awful.spawn.easy_async_with_shell(gfs.get_configuration_dir() .. 'autorun.sh',function()end)
