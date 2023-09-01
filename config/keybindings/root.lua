local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local bling = require("extra.bling")
local apps = require("utils.constats")
local revelation = require("extra.awesome-revelation")
local utils = require("utils")
local keys = require("config.keys")

require("awful.autofocus")

-- https://man.archlinux.org/man/xev.1
local function buttons()
  awful.mouse.append_global_mousebindings({
    awful.button({}, 1, function()
      awesome.emit_signal("module::menu:toggle", false)
    end),
    awful.button({}, 3, function()
      awesome.emit_signal("module::menu:toggle", true)
    end),
    awful.button({}, 2, function()
      awful.util.spawn(apps.appmenu)
    end),
    awful.button({ "Control" }, 2, function()
      awesome.emit_signal("module::exit_screen:show")
    end),
    awful.button({ "Shift" }, 2, function()
      awesome.emit_signal("widget::blue_light:toggle")
    end),
  })

  awful.mouse.append_global_mousebindings({
    awful.button({ "Control" }, 4, function()
      awful.spawn("amixer -D pulse sset Master 5%+", false)
      awesome.emit_signal("widgets::volume")
    end),
    awful.button({ "Control" }, 5, function()
      awful.spawn("amixer -D pulse sset Master 5%-", false)
      awesome.emit_signal("widgets::volume")
    end),
    awful.button({ "Shift" }, 4, function()
      awful.spawn("light -A 10", false)
      awesome.emit_signal("widgets::brightness")
    end),
    awful.button({ "Shift" }, 5, function()
      awful.spawn("light -U 10", false)
      awesome.emit_signal("widgets::brightness")
    end),
  })
end

local function keybindings()
  local modkey = keys.modkey
  local altkey = keys.altkey
  local terminal = apps.terminal

  bling.widget.window_switcher.enable({
    type = "thumbnail", -- set to anything other than "thumbnail" to disable client previews

    -- keybindings (the examples provided are also the default if kept unset)
    hide_window_switcher_key = "Escape", -- The key on which to close the popup
    minimize_key = "n", -- The key on which to minimize the selected client
    unminimize_key = "N", -- The key on which to unminimize all clients
    kill_client_key = "q", -- The key on which to close the selected client
    cycle_key = "Tab", -- The key on which to cycle through all clients
    previous_key = "Left", -- The key on which to select the previous client
    next_key = "Right", -- The key on which to select the next client
    vim_previous_key = "h", -- Alternative key on which to select the previous client
    vim_next_key = "l", -- Alternative key on which to select the next client

    cycleClientsByIdx = utils.raiseVisibleClientsByIdx, -- The function to cycle the clients
    filterClients = utils.clientIsVisible, -- The function to filter the viewed clients
  })

  awful.keyboard.append_global_keybindings({
    group = "awesome",
    awful.key({ modkey }, "F1", hotkeys_popup.show_help, { description = "show help" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome" }),
    awful.key({ modkey, "Control" }, "q", awesome.quit, { description = "quit awesome" }),
    awful.key({ modkey }, "w", function()
      awesome.emit_signal("module::menu:toggle", true)
    end, { description = "show main menu" }),
    awful.key({ modkey }, "l", function()
      awful.spawn(apps.lock, false)
    end, { description = "lock the screen" }),
    awful.key({ altkey }, "Tab", function()
      awesome.emit_signal("bling::window_switcher::turn_on")
    end, { description = "Window Switcher" }),
    awful.key({ modkey }, "Escape", revelation, { description = "Window Switcher" }),
    awful.key({ modkey, "Control", "Shift" }, "t", function()
      awesome.emit_signal("module::rules:titlebar")
    end, { description = "toggle titlebar", group = "client" }),
  })

  awful.keyboard.append_global_keybindings({
    group = "launcher",
    awful.key({ modkey }, "Return", function()
      awful.spawn(terminal)
    end, { description = "open a terminal" }),
    awful.key({ modkey }, "KP_Enter", function()
      awful.spawn(terminal)
    end, { description = "open a terminal" }),
    awful.key({ modkey }, "space", function()
      awesome.emit_signal("widgets::control_center:toggle", false)
      awesome.emit_signal("widgets::info_center:toggle", false)
      awful.spawn(apps.appmenu, false)
    end, { description = "open application drawer" }),
    awful.key({ modkey, "Control" }, "space", function()
      awesome.emit_signal("widgets::control_center:toggle", false)
      awesome.emit_signal("widgets::info_center:toggle", false)
      awful.spawn(apps.globalSearch, false)
    end, { description = "open search rofi" }),
    awful.key({ modkey, "Shift" }, "space", function()
      awesome.emit_signal("widgets::control_center:toggle", false)
      awesome.emit_signal("widgets::info_center:toggle", false)
      awful.spawn(apps.defaultRofi, false)
    end, { description = "open search rofi" }),
    awful.key({ modkey, "Shift" }, "e", function()
      awful.spawn(apps.file_manager)
    end, { description = "open default file manager" }),
    awful.key({ modkey }, "f", function()
      awful.spawn(apps.web_browser)
    end, { description = "open default web browser" }),
    awful.key({ modkey }, "`", function()
      awful.screen.focused().quake:toggle()
    end, { description = "dropdown application" }),
    awful.key({ modkey }, "e", function()
      awful.spawn(apps.file_manager)
    end, { description = "open default file manager" }),
    awful.key({ modkey }, "c", function()
      awful.spawn(apps.ide)
    end, { description = "open default IDE" }),
    awful.key({ modkey }, "g", function()
      awful.spawn(apps.git)
    end, { description = "open default git client" }),
  })

  awful.keyboard.append_global_keybindings({
    group = "media control",
    -- Volume Keys
    -- awful.key({}, "XF86AudioRaiseVolume", function()
    --     awful.spawn("amixer -q -D pulse sset Master 5%+", false)
    --     awesome.emit_signal('widgets::volume')
    -- end, {description = 'increase volume up by 5%'}),
    -- awful.key({}, "XF86AudioLowerVolume", function()
    --     awful.spawn("amixer -q -D pulse sset Master 5%-", false)
    --     awesome.emit_signal('widgets::volume')
    -- end, {description = 'decrease volume up by 5%'}),
    -- awful.key({}, "XF86AudioMute", function()
    --     awful.spawn("amixer -D pulse set Master 1+ toggle", false)
    -- end, {description = 'toggle mute'}),
    awful.key({ "Control" }, "XF86AudioRaiseVolume", function()
      awful.spawn("amixer -q -D pulse sset Capture 5%+", false)
      awesome.emit_signal("widgets::mic:do", 5)
    end, { description = "increase microphone volume up by 5%" }),
    awful.key({ "Control" }, "XF86AudioLowerVolume", function()
      awful.spawn("amixer -q -D pulse sset Capture 5%-", false)
      awesome.emit_signal("widgets::mic:do", -5)
    end, { description = "decrease microphone volume up by 5%" }),
    awful.key({ "Control" }, "XF86AudioMute", function()
      awful.spawn("amixer set Capture toggle", false)
      awesome.emit_signal("widgets::mic:do", 0)
    end, { description = "mute microphone" }),
    awful.key({}, "XF86AudioMicMute", function()
      awful.spawn("amixer set Capture toggle", false)
      awesome.emit_signal("widgets::mic:do", 0)
    end, { description = "mute microphone" }),
    -- Media Keys
    awful.key({}, "XF86AudioPlay", function()
      awful.spawn("playerctl play-pause", false)
    end, { description = "play/pause music" }),
    awful.key({}, "XF86AudioNext", function()
      awful.spawn("playerctl next", false)
    end, { description = "next music" }),
    awful.key({}, "XF86AudioPrev", function()
      awful.spawn("playerctl previous", false)
    end, { description = "previous music" }),

    awful.key({ "Control", "Shift" }, "XF86AudioRaiseVolume", function()
      awful.spawn("light -A 10", false)
      awesome.emit_signal("widgets::brightness")
    end, { description = "increase brightness by 10%" }),
    awful.key({}, "XF86MonBrightnessUp", function()
      awful.spawn("light -A 10", false)
      awesome.emit_signal("widgets::brightness")
    end, { description = "increase brightness by 10%" }),
    awful.key({ "Control", "Shift" }, "XF86AudioLowerVolume", function()
      awful.spawn("light -U 10", false)
      awesome.emit_signal("widgets::brightness")
    end, { description = "decrease brightness by 10%" }),
    awful.key({}, "XF86MonBrightnessDown", function()
      awful.spawn("light -U 10", false)
      awesome.emit_signal("widgets::brightness")
    end, { description = "decrease brightness by 10%" }),
  })

  awful.keyboard.append_global_keybindings({
    group = "awesome",
    awful.key({}, "XF86PowerOff", function()
      awesome.emit_signal("module::exit_screen:show")
    end, { description = "toggle exit screen" }),
    awful.key({}, "XF86Display", function()
      awful.spawn.single_instance("arandr", false)
    end, { description = "arandr", group = "hotkeys" }),
    awful.key({ modkey, "Shift" }, "q", function()
      awesome.emit_signal("module::exit_screen:show")
    end, { description = "toggle exit screen" }),
    awful.key({}, "Print", function()
      awful.spawn.easy_async_with_shell(apps.full_screenshot, function() end)
    end, { description = "fullscreen screenshot" }),
    awful.key({ "Shift" }, "Print", function()
      awful.spawn.easy_async_with_shell(apps.area_screenshot, function() end)
    end, { description = "area/selected screenshot" }),
  })

  awful.keyboard.append_global_keybindings({
    group = "tag",
    awful.key({ modkey, "Control" }, "w", awful.tag.viewprev, { description = "view previous tag" }),
    awful.key({ modkey, "Control" }, "s", awful.tag.viewnext, { description = "view next tag" }),
    awful.key(
      { modkey, "Control" },
      "Escape",
      awful.tag.history.restore,
      { description = "alternate between current and previous tag" }
    ),

    awful.key({ modkey, "Shift" }, "w", function()
      -- tag_view_nonempty(-1)
      local focused = awful.screen.focused()
      for i = 1, #focused.tags do
        awful.tag.viewidx(-1, focused)
        if #focused.clients > 0 then
          return
        end
      end
    end, { description = "view previous non-empty tag" }),
    awful.key({ modkey, "Shift" }, "s", function()
      -- tag_view_nonempty(1)
      local focused = awful.screen.focused()
      for i = 1, #focused.tags do
        awful.tag.viewidx(1, focused)
        if #focused.clients > 0 then
          return
        end
      end
    end, { description = "view next non-empty tag" }),
  })

  awful.keyboard.append_global_keybindings({
    group = "screen",
    awful.key({ modkey }, "F2", function()
      awful.screen.focus_relative(-1)
    end, { description = "focus the previous screen" }),
    awful.key({ modkey, "Shift" }, "F2", function()
      awful.screen.focus_relative(1)
    end, { description = "focus the next screen" }),
    awful.key({ modkey, "Control" }, "n", function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal("request::activate")
        c:raise()
      end
    end, { description = "restore minimized" }),
  })

  awful.keyboard.append_global_keybindings({
    group = "utilities",
    awful.key({ modkey, "Shift" }, "x", function()
      awesome.emit_signal("widgets::blur")
    end, { description = "toggle blur effects" }),
    awful.key({ modkey, "Shift" }, "]", function()
      awesome.emit_signal("widgets::blur:increase")
    end, { description = "increase blur effect by 10%" }),
    awful.key({ modkey, "Shift" }, "[", function()
      awesome.emit_signal("widgets::blur:decrease")
    end, { description = "decrease blur effect by 10%" }),
    awful.key({ modkey, "Shift" }, "t", function()
      awesome.emit_signal("widgets::blue_light")
    end, { description = "toggle redshift filter" }),
  })

  awful.keyboard.append_global_keybindings({
    group = "layout",
    awful.key({ altkey, "Shift" }, "l", function()
      awful.tag.incmwfact(0.05)
    end, { description = "increase master width factor" }),
    awful.key({ altkey, "Shift" }, "h", function()
      awful.tag.incmwfact(-0.05)
    end, { description = "decrease master width factor" }),
    awful.key({ modkey, "Shift" }, "h", function()
      awful.tag.incnmaster(1, nil, true)
    end, { description = "increase the number of master clients" }),
    awful.key({ modkey, "Shift" }, "l", function()
      awful.tag.incnmaster(-1, nil, true)
    end, { description = "decrease the number of master clients" }),
    awful.key({ modkey, "Control" }, "h", function()
      awful.tag.incncol(1, nil, true)
    end, { description = "increase the number of columns" }),
    awful.key({ modkey, "Control" }, "l", function()
      awful.tag.incncol(-1, nil, true)
    end, { description = "decrease the number of columns" }),
    awful.key({ modkey }, "F3", function()
      awful.layout.inc(1)
    end, { description = "select next layout" }),
    awful.key({ modkey, "Shift" }, "F3", function()
      awful.layout.inc(-1)
    end, { description = "select previous layout" }),
    awful.key({ modkey, "Control" }, "o", function()
      awful.tag.incgap(1)
    end, { description = "increase gap" }),
    awful.key({ modkey, "Control", "Shift" }, "o", function()
      awful.tag.incgap(-1)
    end, { description = "decrease gap" }),
  })
end

return function()
  revelation.init()
  buttons()
  keybindings()
end
