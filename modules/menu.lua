local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local menu = require("extra.freedesktop.menu")
local apps = require("utils.constats")

local terminal = apps.terminal
local web_browser = apps.web_browser
local file_manager = apps.file_manager
local text_editor = apps.text_editor
local editor_cmd = terminal .. " -e " .. (os.getenv("EDITOR") or "nano")
local full_screenshot = apps.full_screenshot
local area_screenshot = apps.area_screenshot

-- Create a launcher widget and a main menu
local awesome_menu = {
  {
    "Hotkeys",
    function()
      hotkeys_popup.show_help(nil, awful.screen.focused())
    end,
    menubar.utils.lookup_icon("keyboard"),
  },
  { "Edit config", editor_cmd .. " " .. awesome.conffile, menubar.utils.lookup_icon("accessories-text-editor") },
  { "Restart", awesome.restart, menubar.utils.lookup_icon("system-restart") },
  {
    "Quit",
    function()
      awesome.quit()
    end,
    menubar.utils.lookup_icon("system-log-out"),
  },
}

local default_app_menu = {
  { "Terminal", terminal, menubar.utils.lookup_icon("utilities-terminal") },
  { "Web browser", web_browser, menubar.utils.lookup_icon("webbrowser-app") },
  { "File Manager", file_manager, menubar.utils.lookup_icon("system-file-manager") },
  { "Text Editor", text_editor, menubar.utils.lookup_icon("accessories-text-editor") },
}

-- Screenshot menu
local screenshot_menu = {
  {
    "Full",
    function()
      gears.timer.start_new(0.1, function()
        awful.spawn.easy_async_with_shell(full_screenshot)
      end)
    end,
    menubar.utils.lookup_icon("accessories-screenshot"),
  },
  {
    "Area",
    function()
      gears.timer.start_new(0.1, function()
        awful.spawn.easy_async_with_shell(area_screenshot)
      end)
    end,
    menubar.utils.lookup_icon("accessories-screenshot"),
  },
}

local tools_menu = {
  { "Awesome", awesome_menu, beautiful.awesome_icon },
  { "Take a Screenshot", screenshot_menu, menubar.utils.lookup_icon("accessories-screenshot") },
  {
    "End Session",
    function()
      awesome.emit_signal("module::exit_screen:show")
    end,
    menubar.utils.lookup_icon("system-shutdown"),
  },
}

local mymainmenu = menu.build({
  -- Not actually the size, but the quality of the icon
  icon_size = 48,
  before = default_app_menu,
  after = tools_menu,
})

awesome.connect_signal("module::menu:toggle", function(bool)
  if bool then
    mymainmenu:toggle()
  else
    mymainmenu:hide()
  end
end)

return mymainmenu
