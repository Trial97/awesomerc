local awful = require("awful")
local top_panel = require("modules.top-panel")
local quake = require("modules.quake-terminal")
local sharedtags = require("extra.sharedtags")
local icons = require("themes.icons")
local osd = require("widgets.osd")
local controlCenter = require("widgets.control-center")
local infoCenter = require("widgets.info-center")

local spawn = awful.spawn
local volume = osd("volume", "Volume", icons.volume, function(level, pressed)
  if pressed then
    spawn("amixer -D pulse sset Master " .. level .. "%", false)
  end
  awesome.emit_signal("widgets::volume:update", level)
end)

local mic = osd("mic", "Microphone", icons.mic, function(level, pressed)
  if pressed then
    spawn("amixer -D pulse sset Capture " .. level .. "%", false)
  end
end)

local bri = osd("brightness", "Brightness", icons.brightness, function(level, pressed)
  if pressed then
    spawn("light -S " .. math.max(level, 5), false)
  end
end)

local function set_tags(s, tags)
  tags[s.index].screen = s
  sharedtags.viewonly(tags[s.index], s)
end

-- Hide bars when app go fullscreen
local function update_bars_visibility()
  for s in screen do
    if s.selected_tag then
      local fullscreen = s.selected_tag.fullscreen_mode
      -- Order matter here for shadow
      if s.top_panel then
        s.top_panel.visible = not fullscreen
      end
      awesome.emit_signal("widgets::control_center:toggle", false)
      awesome.emit_signal("widgets::info_center:toggle", false)
    end
  end
end

return function(tags)
  awful.screen.connect_for_each_screen(function(s)
    set_tags(s, tags)
    volume(s)
    mic(s)
    bri(s)
    s.control_center = controlCenter(s)
    s.info_center = infoCenter(s)
    s.quake = quake
    s.top_panel = top_panel(s)
    awesome.emit_signal("module::exit_screen:redraw")
  end)
  screen.connect_signal("removed", function()
    awesome.emit_signal("module::exit_screen:redraw")
  end)
  screen.connect_signal("primary_changed", function()
    awesome.emit_signal("module::exit_screen:redraw")
  end)
  screen.connect_signal("added", function()
    awesome.emit_signal("module::exit_screen:redraw")
  end)
  screen.connect_signal("swapped", function()
    awesome.emit_signal("module::exit_screen:redraw")
  end)
  screen.connect_signal("property::viewports", function()
    awesome.emit_signal("module::exit_screen:redraw")
  end)

  tag.connect_signal("property::selected", function()
    update_bars_visibility()
  end)

  client.connect_signal("property::fullscreen", function(c)
    if c.first_tag then
      c.first_tag.fullscreen_mode = c.fullscreen
    end
    update_bars_visibility()
  end)

  client.connect_signal("unmanage", function(c)
    if c.fullscreen then
      c.screen.selected_tag.fullscreen_mode = false
      update_bars_visibility()
    end
  end)

  awesome.emit_signal("module::exit_screen:redraw")
end
