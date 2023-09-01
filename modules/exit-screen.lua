local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local icons = require("themes.icons")
local click_container = require("widgets.clickable-container")
local apps = require("utils.constats")
local utils = require("utils")

local dpi = beautiful.xresources.apply_dpi
local default_profile = beautiful.get().user_profile_image or beautiful.get().icons .. "user-profile/default.svg"
local lock_cmd = apps.lock or "lock"
local msg_table = {
  "See you later, alligator!",
  "After a while, crocodile.",
  "Stay out of trouble.",
  "I’m out of here.",
  "Yamete, onii-chan~. UwU",
  "Okay...bye, fry guy!",
  "Peace out!",
  "Peace out, bitch!",
  "Gotta get going.",
  "Out to the door, dinosaur.",
  "Don't forget to come back!",
  "Smell ya later!",
  "In a while, crocodile.",
  "Adios, amigo.",
  "Begone!",
  "Arrivederci.",
  "Never look back!",
  "So long, sucker!",
  "Au revoir!",
  "Later, skater!",
  "That'll do pig. That'll do.",
  "Happy trails!",
  "Smell ya later!",
  "See you soon, baboon!",
  "Bye Felicia!",
  "Sayonara!",
  "Ciao!",
  "Well.... bye.",
  "Delete your browser history!",
  "See you, Space Cowboy!",
  "Change da world. My final message. Goodbye.",
  "Find out on the next episode of Dragonball Z...",
  "Choose wisely!",
}

local greeter_message = wibox.widget({
  markup = "Choose wisely!",
  font = "Inter UltraLight 48",
  align = "center",
  valign = "center",
  widget = wibox.widget.textbox,
})

local profile_name = wibox.widget({
  markup = "user@hostname",
  font = "Inter Bold 12",
  align = "center",
  valign = "center",
  widget = wibox.widget.textbox,
})

local profile_imagebox = wibox.widget({
  image = default_profile,
  resize = true,
  forced_height = dpi(140),
  clip_shape = gears.shape.circle,
  widget = wibox.widget.imagebox,
})

local function update_greeter_msg()
  greeter_message:set_markup(msg_table[math.random(#msg_table)])
  greeter_message:emit_signal("widget::redraw_needed")
end

local build_power_button = function(name, icon, callback)
  local power_button_label = wibox.widget({
    text = name,
    font = "Inter Regular 10",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
  })

  local power_button = wibox.widget({
    {
      {
        {
          {
            image = icon,
            widget = wibox.widget.imagebox,
          },
          margins = dpi(16),
          widget = wibox.container.margin,
        },
        bg = beautiful.groups_bg,
        widget = wibox.container.background,
      },
      shape = gears.shape.rounded_rect,
      forced_width = dpi(90),
      forced_height = dpi(90),
      widget = click_container,
    },
    left = dpi(24),
    right = dpi(24),
    widget = wibox.container.margin,
  })

  local exit_screen_item = wibox.widget({
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(5),
    power_button,
    power_button_label,
  })

  exit_screen_item:connect_signal("button::release", function()
    awesome.emit_signal("module::exit_screen:hide")
    callback()
  end)
  return exit_screen_item
end

local function suspend_command()
  awful.spawn.with_shell("systemctl suspend")
end

local function logout_command()
  awesome.quit()
end

local function lock_command()
  awful.spawn.with_shell(lock_cmd)
end

local function poweroff_command()
  awful.spawn.with_shell("poweroff")
end

local function reboot_command()
  awful.spawn.with_shell("reboot")
end

local poweroff = build_power_button("Shutdown", icons.power, poweroff_command)
local reboot = build_power_button("Restart", icons.restart, reboot_command)
local suspend = build_power_button("Sleep", icons.sleep, suspend_command)
local logout = build_power_button("Logout", icons.logout, logout_command)
local lock = build_power_button("Lock", icons.lock, lock_command)

local function create_base_exit_screen(s)
  local exit_screen = wibox({
    screen = s,
    type = "splash",
    visible = false,
    ontop = true,
    bg = beautiful.background,
    fg = beautiful.fg_normal,
    height = s.geometry.height,
    width = s.geometry.width,
    x = s.geometry.x,
    y = s.geometry.y,
  })

  exit_screen:buttons({
    awful.button({}, 2, function()
      awesome.emit_signal("module::exit_screen:hide")
    end),
    awful.button({}, 3, function()
      awesome.emit_signal("module::exit_screen:hide")
    end),
  })
  return exit_screen
end

local create_exit_screen = function(s)
  s.exit_second_screen = create_base_exit_screen(s)
  s.exit_screen = create_base_exit_screen(s)
  s.exit_screen:setup({
    layout = wibox.layout.align.vertical,
    expand = "none",
    nil,
    {
      layout = wibox.layout.align.vertical,
      {
        nil,
        {
          layout = wibox.layout.fixed.vertical,
          spacing = dpi(5),
          {
            layout = wibox.layout.align.vertical,
            expand = "none",
            nil,
            {
              layout = wibox.layout.align.horizontal,
              expand = "none",
              nil,
              profile_imagebox,
              nil,
            },
            nil,
          },
          profile_name,
        },
        nil,
        expand = "none",
        layout = wibox.layout.align.horizontal,
      },
      {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        nil,
        {
          widget = wibox.container.margin,
          margins = dpi(15),
          greeter_message,
        },
        nil,
      },
      {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        nil,
        {
          {
            {
              poweroff,
              reboot,
              suspend,
              logout,
              lock,
              layout = wibox.layout.fixed.horizontal,
            },
            spacing = dpi(30),
            layout = wibox.layout.fixed.vertical,
          },
          widget = wibox.container.margin,
          margins = dpi(15),
        },
        nil,
      },
    },
    nil,
  })
end

local exit_screen_grabber = awful.keygrabber({
  auto_start = false,
  stop_event = "release",
  keypressed_callback = function(self, mod, key, command)
    local key = string.lower(key)
    if key == "s" then
      awesome.emit_signal("module::exit_screen:hide")
      suspend_command()
    elseif key == "e" then
      awesome.emit_signal("module::exit_screen:hide")
      logout_command()
    elseif key == "l" then
      awesome.emit_signal("module::exit_screen:hide")
      lock_command()
    elseif key == "p" then
      awesome.emit_signal("module::exit_screen:hide")
      poweroff_command()
    elseif key == "r" then
      awesome.emit_signal("module::exit_screen:hide")
      reboot_command()
    elseif key == "escape" or key == "q" or key == "x" then
      awesome.emit_signal("module::exit_screen:hide")
    end
  end,
})

awesome.connect_signal("module::exit_screen:redraw", function()
  for s in screen do
    create_exit_screen(s)
  end
end)

utils.update_user_name(function(stdout)
  profile_name:set_markup(stdout)
  profile_name:emit_signal("widget::redraw_needed")
end)

update_greeter_msg()

awesome.connect_signal("module::exit_screen:show", function()
  for s in screen do
    s.exit_second_screen.visible = true
    s.exit_screen.visible = false
  end
  awful.screen.focused().exit_second_screen.visible = false
  awful.screen.focused().exit_screen.visible = true
  exit_screen_grabber:start()
end)

awesome.connect_signal("module::exit_screen:hide", function()
  update_greeter_msg()
  exit_screen_grabber:stop()
  for s in screen do
    s.exit_second_screen.visible = false
    s.exit_screen.visible = false
  end
end)

gears.timer({
  timeout = 5,
  autostart = true,
  call_now = true,
  single_shot = true,
  callback = function()
    awesome.emit_signal("module::exit_screen:redraw")
  end,
})
