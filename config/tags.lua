local awful = require('awful')
local beautiful = require('beautiful')
local sharedtags = require('extra.sharedtags')
local keys = require('config.keys')

local modkey = keys.modkey
local tagnames = { '1', '2', '3', '4', '5', '6', '7', '8', '9', '10' }

local function prepare_tags(tagnames)
  local tags = {}
  for _, name in ipairs(tagnames) do
    table.insert(tags, {
      name = name,
      layout = awful.layout.suit.max,
      gap_single_client = true,
      gap = beautiful.useless_gap,
    })
  end
  return sharedtags(tags)
end
local tags = prepare_tags(tagnames)

tag.connect_signal('request::default_layouts', function()
  awful.layout.append_default_layouts({
    awful.layout.suit.floating,
    awful.layout.suit.max,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.tile,

    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
  })
end)

local update_gap_and_shape = function(t)
  -- Get current tag layout
  local current_layout = awful.tag.getproperty(t, 'layout')
  -- If the current layout is awful.layout.suit.max
  if current_layout == awful.layout.suit.max then
    -- Set clients gap to 0 and shape to rectangle if maximized
    t.gap = 0
    for _, c in ipairs(t:clients()) do
      if not c.floating or not c.round_corners or c.maximized or c.fullscreen then
        c.shape = beautiful.client_shape_rectangle
      else
        c.shape = beautiful.client_shape_rounded
      end
    end
  else
    t.gap = beautiful.useless_gap
    for _, c in ipairs(t:clients()) do
      if not c.round_corners or c.maximized or c.fullscreen then
        c.shape = beautiful.client_shape_rectangle
      else
        c.shape = beautiful.client_shape_rounded
      end
    end
  end
end

-- Change tag's client's shape and gap on change
tag.connect_signal('property::layout', function(t)
  update_gap_and_shape(t)
end)

-- Change tag's client's shape and gap on move to tag
tag.connect_signal('tagged', function(t)
  update_gap_and_shape(t)
end)

-- Focus on urgent clients
awful.tag.attached_connect_signal(nil, 'property::selected', function()
  for c in
    awful.client.iterate(function(c)
      return awful.rules.match(c, { urgent = true })
    end)
  do
    if c.first_tag == mouse.screen.selected_tag then
      c:emit_signal('request::activate')
      c:raise()
    end
  end
end)

local function set_tag(s, tag)
  tag.screen = s
  sharedtags.viewonly(tag, s)
end

local function addTag2Screen(s)
  -- no screen
  for _, t in pairs(tags) do
    if t.screen == nil then
      set_tag(s, t)
      return
    end
  end
  -- not selected
  for _, t in pairs(tags) do
    if not t.selected then
      set_tag(s, t)
      return
    end
  end
end

local function update_tags()
  for s in screen do
    if not s.selected_tag then
      addTag2Screen(s)
    end
  end
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  awful.keyboard.append_global_keybindings({
    group = 'tag',
    -- View tag only.
    awful.key({ modkey }, '#' .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = tags[i]
      if tag then
        sharedtags.viewonly(tag, screen)
        update_tags()
      end
    end, { description = 'view tag #' .. i }),
    -- Toggle tag display.
    awful.key({ modkey, 'Control' }, '#' .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = tags[i]
      if tag then
        sharedtags.viewtoggle(tag, screen)
        update_tags()
      end
    end, { description = 'toggle tag #' .. i }),
    -- Move client to tag.
    awful.key({ modkey, 'Shift' }, '#' .. i + 9, function()
      if client.focus then
        local tag = tags[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end, { description = 'move focused client to tag #' .. i }),
    -- Toggle tag on focused client.
    awful.key({ modkey, 'Control', 'Shift' }, '#' .. i + 9, function()
      if client.focus then
        local tag = tags[i]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end, { description = 'toggle focused client on tag #' .. i }),
  })
end

return tags
