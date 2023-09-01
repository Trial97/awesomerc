local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local click_container = require("widgets.clickable-container")
local bling = require("extra.bling")

local dpi = beautiful.xresources.apply_dpi
local widget_icon_dir = beautiful.get().icons .. "widgets/mpd/"
local playerctl = bling.signal.playerctl.lib()

local album_cover = wibox.widget({
  {
    id = "cover",
    image = widget_icon_dir .. "vinyl.svg",
    resize = true,
    clip_shape = gears.shape.rounded_rect,
    forced_width = dpi(60),
    widget = wibox.widget.imagebox,
  },
  layout = wibox.layout.fixed.vertical,
})

local music_title = wibox.widget({
  layout = wibox.layout.fixed.horizontal,
  expand = "none",
  {
    {
      id = "title",
      text = "title",
      font = "Inter Bold 10",
      align = "left",
      valign = "center",
      ellipsize = "end",
      widget = wibox.widget.textbox,
    },
    id = "scroll_container",
    max_size = 150,
    speed = 75,
    expand = true,
    direction = "h",
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
    fps = 60,
    layout = wibox.container.scroll.horizontal,
  },
})

local music_artist = wibox.widget({
  layout = wibox.layout.fixed.horizontal,
  expand = "none",
  {
    {
      id = "artist",
      text = "artist",
      font = "Inter Regular 10",
      align = "left",
      valign = "center",
      widget = wibox.widget.textbox,
    },
    id = "scroll_container",
    max_size = 150,
    speed = 75,
    expand = true,
    direction = "h",
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
    fps = 60,
    layout = wibox.container.scroll.horizontal,
  },
})

local music_info = wibox.widget({
  layout = wibox.layout.align.vertical,
  expand = "none",
  nil,
  {
    layout = wibox.layout.fixed.vertical,
    music_title,
    music_artist,
  },
  nil,
})

local play_button_image = wibox.widget({
  {
    id = "play",
    image = widget_icon_dir .. "play.svg",
    resize = true,
    opacity = 0.8,
    widget = wibox.widget.imagebox,
  },
  layout = wibox.layout.align.horizontal,
})

local next_button_image = wibox.widget({
  {
    id = "next",
    image = widget_icon_dir .. "next.svg",
    resize = true,
    opacity = 0.8,
    widget = wibox.widget.imagebox,
  },
  layout = wibox.layout.align.horizontal,
})

local prev_button_image = wibox.widget({
  {
    id = "prev",
    image = widget_icon_dir .. "prev.svg",
    resize = true,
    opacity = 0.8,
    widget = wibox.widget.imagebox,
  },
  layout = wibox.layout.align.horizontal,
})

local play_button = wibox.widget({
  {
    {
      play_button_image,
      margins = dpi(7),
      widget = wibox.container.margin,
    },
    widget = click_container,
  },
  forced_width = dpi(36),
  forced_height = dpi(36),
  bg = beautiful.transparent,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
  end,
  widget = wibox.container.background,
})

local next_button = wibox.widget({
  {
    {
      next_button_image,
      margins = dpi(10),
      widget = wibox.container.margin,
    },
    widget = click_container,
  },
  forced_width = dpi(36),
  forced_height = dpi(36),
  bg = beautiful.transparent,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
  end,
  widget = wibox.container.background,
})

local prev_button = wibox.widget({
  {
    {
      prev_button_image,
      margins = dpi(10),
      widget = wibox.container.margin,
    },
    widget = click_container,
  },
  forced_width = dpi(36),
  forced_height = dpi(36),
  bg = beautiful.transparent,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
  end,
  widget = wibox.container.background,
})

local navigate_buttons = wibox.widget({
  layout = wibox.layout.fixed.horizontal,
  prev_button,
  play_button,
  next_button,
})

play_button:buttons({ awful.button({}, 1, nil, function()
  playerctl:play_pause()
end) })
next_button:buttons({ awful.button({}, 1, nil, function()
  playerctl:next()
end) })
prev_button:buttons({ awful.button({}, 1, nil, function()
  playerctl:previous()
end) })

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
  -- title
  local title_text = music_title:get_children_by_id("title")[1]
  -- Make sure it's not null
  if not (title == nil or title == "") then
    title_text:set_text(title)
  else
    title_text:set_text("Play some music!")
  end

  -- artist
  local artist_text = music_artist:get_children_by_id("artist")[1]
  if not (artist == nil or artist == "") then
    artist_text:set_text(artist)
  elseif not (player_name == nil or player_name == "") then
    artist_text:set_text("unknown artist")
  else
    artist_text:set_text("or play some porn?")
  end

  -- cover
  local album_icon = widget_icon_dir .. "vinyl" .. ".svg"
  if not (album_path == nil or album_path == "") then
    album_icon = album_path
  end
  album_cover.cover:set_image(gears.surface.load_uncached(album_icon))

  music_title:emit_signal("widget::redraw_needed")
  music_title:emit_signal("widget::layout_changed")
  music_artist:emit_signal("widget::redraw_needed")
  music_artist:emit_signal("widget::layout_changed")
  album_cover:emit_signal("widget::redraw_needed")
  album_cover:emit_signal("widget::layout_changed")
  collectgarbage("collect")
end)

playerctl:connect_signal("playback_status", function(_, playing, player_name)
  if playing then
    play_button_image.play:set_image(widget_icon_dir .. "pause.svg")
  else
    play_button_image.play:set_image(widget_icon_dir .. "play.svg")
  end
end)

playerctl:connect_signal("no_players", function()
  require("utils").log(2, "no_players\n")
end)

return wibox.widget({
  layout = wibox.layout.align.horizontal,
  forced_height = dpi(46),
  {
    layout = wibox.layout.fixed.horizontal,
    spacing = dpi(10),
    album_cover,
    music_info,
  },
  nil,
  {
    layout = wibox.layout.align.vertical,
    expand = "none",
    nil,
    navigate_buttons,
    nil,
  },
})
