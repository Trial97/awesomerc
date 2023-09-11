local awful = require('awful')
local ruled = require('ruled')
local beautiful = require('beautiful')

local titlebars_enabled = false
awesome.connect_signal('module::rules:titlebar', function()
  titlebars_enabled = not titlebars_enabled
  for _, c in ipairs(client.get()) do
    if titlebars_enabled then
      awful.titlebar.show(c)
    else
      awful.titlebar.hide(c)
    end
  end
end)

ruled.client.connect_signal('request::rules', function()
  -- All clients will match this rule.
  ruled.client.append_rule({
    id = 'global',
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      raise = true,
      screen = awful.screen.preferred,
      floating = false,
      maximized = false,
      above = false,
      below = false,
      ontop = false,
      sticky = false,
      maximized_horizontal = false,
      maximized_vertical = false,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    },
  })

  ruled.client.append_rule({
    id = 'round_clients',
    rule_any = { type = { 'normal', 'dialog' } },
    except_any = { name = { 'Discord Updater' } },
    properties = {
      round_corners = true,
      shape = beautiful.client_shape_rounded,
    },
  })

  -- Titlebar rules
  ruled.client.append_rule({
    id = 'titlebars',
    rule_any = { type = { 'normal', 'dialog', 'modal', 'utility' } },
    properties = { titlebars_enabled = titlebars_enabled },
  })

  -- Dialogs and modals
  ruled.client.append_rule({
    id = 'dialog',
    rule_any = {
      type = { 'dialog', 'modal' },
      class = { 'Wicd-client.py', 'calendar.google.com' },
    },
    properties = {
      titlebars_enabled = titlebars_enabled,
      floating = true,
      above = true,
      skip_decoration = true,
      placement = awful.placement.centered,
    },
  })

  -- Utilities
  ruled.client.append_rule({
    id = 'utility',
    rule_any = { type = { 'utility' } },
    properties = {
      titlebars_enabled = false,
      floating = true,
      skip_decoration = true,
      placement = awful.placement.centered,
    },
  })

  -- Splash
  ruled.client.append_rule({
    id = 'splash',
    rule_any = {
      type = { 'splash' },
      name = { 'Discord Updater' },
    },
    properties = {
      titlebars_enabled = false,
      round_corners = false,
      floating = true,
      above = true,
      skip_decoration = true,
      placement = awful.placement.centered,
    },
  })

  -- Terminal emulators
  ruled.client.append_rule({
    id = 'terminals',
    rule_any = { class = { 'URxvt', 'XTerm', 'UXTerm', 'kitty', 'K3rmit' } },
    properties = {
      size_hints_honor = false,
      titlebars_enabled = titlebars_enabled,
    },
  })

  -- Multimedia
  ruled.client.append_rule({
    id = 'multimedia',
    rule_any = { class = { 'vlc', 'Spotify' } },
    properties = { placement = awful.placement.centered },
  })

  -- Gaming
  ruled.client.append_rule({
    id = 'gaming',
    rule_any = {
      class = { 'Wine', 'dolphin-emu', 'Steam', 'Citra', 'supertuxkart' },
      name = { 'Steam' },
    },
    properties = {
      skip_decoration = true,
      placement = awful.placement.centered,
    },
  })

  -- IDEs and Tools
  ruled.client.append_rule({
    id = 'development',
    rule_any = {
      class = { 'Oomox', 'Unity', 'UnityHub', 'jetbrains-studio', 'Ettercap', 'scrcpy' },
    },
    properties = { skip_decoration = true },
  })

  -- Image viewers
  ruled.client.append_rule({
    id = 'image_viewers',
    rule_any = { class = { 'feh', 'Pqiv', 'Sxiv' } },
    properties = {
      titlebars_enabled = titlebars_enabled,
      skip_decoration = true,
      floating = true,
      ontop = true,
      placement = awful.placement.centered,
    },
  })

  -- Floating
  ruled.client.append_rule({
    id = 'floating',
    rule_any = {
      instance = { 'file_progress', 'Popup', 'nm-connection-editor', 'copyq', 'pinentry' },
      class = {
        'scrcpy',
        'Mugshot',
        'Pulseeffects',
        'Arandr',
        'Gpick',
        'Kruler',
        'Sxiv',
        'Tor Browser',
        'Wpa_gui',
        'veromix',
        'xtightvncviewer',
        'Blueberry',
        'Galculator',
        'Gnome-font-viewer',
        'Imagewriter',
        'Font-manager',
        'MessageWin',
        'Oblogout',
        'Peek',
        'Skype',
        'System-config-printer.py',
        'Unetbootin.elf',
        'pinentry',
        'xfce4-notes',
        'Xfce4-notes',
      },
      name = { 'Event Tester' },
      role = { 'AlarmWindow', 'ConfigManager', 'pop-up', 'Preferences', 'setup' },
    },
    properties = {
      titlebars_enabled = titlebars_enabled,
      skip_decoration = true,
      ontop = true,
      floating = true,
      focus = awful.client.focus.filter,
      raise = true,
      placement = awful.placement.centered,
    },
  })
end)

ruled.notification.connect_signal('request::rules', function()
  -- All notifications will match this rule.
  ruled.notification.append_rule({
    rule = {},
    properties = {
      screen = awful.screen.preferred,
      implicit_timeout = 5,
    },
  })
end)

-- Normally we'd do this with a rule, but some program like spotify doesn't set its class or name
-- until after it starts up, so we need to catch that signal.
client.connect_signal('property::class', function(c)
  if c.class == 'Spotify' then
    -- Check if Spotify is already open
    for c2 in
      awful.client.iterate(function(c3)
        return ruled.client.match(c3, { class = 'Spotify' })
      end)
    do
      -- If Spotify is already open, don't open a new instance
      c:kill()
      c2:jump_to(false)
      return
    end

    -- Fullscreen mode if not window mode
    if not c.fullscreen then
      c.floating = true
      awful.placement.centered(c, { honor_workarea = true })
    end
  elseif c.class == 'Xfce4-notes' then
    c.floating = true
    c.ontop = true
  end
end)
