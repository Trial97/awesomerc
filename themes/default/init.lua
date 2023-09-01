local beautiful = require("beautiful")
local gfs = require("gears.filesystem")
local rnotification = require("ruled.notification")

local dpi = beautiful.xresources.apply_dpi
local theme_assets = beautiful.theme_assets

return function(theme)
  -- Directories
  theme.dir = gfs.get_themes_dir()
  theme.icons = theme.dir .. "/icons/"

  -- Font
  theme.font = "Inter Regular 10"
  theme.font_bold = "Inter Bold 10"

  -- Background
  theme.bg_normal = "#222222"
  theme.bg_focus = "#535d6c"
  theme.bg_urgent = "#ff0000"
  theme.bg_minimize = "#444444"
  theme.bg_systray = theme.bg_normal

  -- Foreground
  theme.fg_normal = "#aaaaaa"
  theme.fg_focus = "#ffffff"
  theme.fg_urgent = "#ffffff"
  theme.fg_minimize = "#ffffff"

  -- Transparent
  theme.transparent = "#00000000"

  -- Border
  theme.useless_gap = dpi(4)
  theme.border_width = dpi(0)
  theme.border_color = theme.transparent
  theme.border_color_normal = theme.border_color
  theme.border_color_active = theme.border_color
  theme.border_color_marked = theme.border_color

  -- There are other variable sets
  -- overriding the default one when
  -- defined, the sets are:
  -- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
  -- tasklist_[bg|fg]_[focus|urgent]
  -- titlebar_[bg|fg]_[normal|focus]
  -- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
  -- prompt_[fg|bg|fg_cursor|bg_cursor|font]
  -- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
  -- Example:
  --theme.taglist_bg_focus = "#ff0000"

  -- Generate taglist squares:
  -- local taglist_square_size = dpi(4)
  -- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
  --     taglist_square_size, theme.fg_normal
  -- )
  -- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
  --     taglist_square_size, theme.fg_normal
  -- )

  theme.wallpaper = theme.dir .. "/wallpapers/default.png"
  theme.awesome_icon = theme.icons .. "awesome.svg"

  -- Menu icon theme
  theme.icon_theme = "Tela-blue-dark"

  -- Variables set for theming notifications:
  -- notification_font
  -- notification_[bg|fg]
  -- notification_[width|height|margin]
  -- notification_[border_color|border_width|shape|opacity]

  -- Variables set for theming the menu:
  -- menu_[bg|fg]_[normal|focus]
  -- menu_[border_color|border_width]
  theme.menu_submenu_icon = theme.dir .. "default/submenu.png"
  theme.menu_height = dpi(15)
  theme.menu_width = dpi(100)

  -- You can add as many variables as
  -- you wish and access them by using
  -- beautiful.variable in your rc.lua
  --theme.bg_widget = "#cc0000"

  -- Define the image to load
  theme.titlebar_close_button_normal = theme.dir .. "default/titlebar/close_normal.png"
  theme.titlebar_close_button_focus = theme.dir .. "default/titlebar/close_focus.png"

  theme.titlebar_minimize_button_normal = theme.dir .. "default/titlebar/minimize_normal.png"
  theme.titlebar_minimize_button_focus = theme.dir .. "default/titlebar/minimize_focus.png"

  theme.titlebar_ontop_button_normal_inactive = theme.dir .. "default/titlebar/ontop_normal_inactive.png"
  theme.titlebar_ontop_button_focus_inactive = theme.dir .. "default/titlebar/ontop_focus_inactive.png"
  theme.titlebar_ontop_button_normal_active = theme.dir .. "default/titlebar/ontop_normal_active.png"
  theme.titlebar_ontop_button_focus_active = theme.dir .. "default/titlebar/ontop_focus_active.png"

  theme.titlebar_sticky_button_normal_inactive = theme.dir .. "default/titlebar/sticky_normal_inactive.png"
  theme.titlebar_sticky_button_focus_inactive = theme.dir .. "default/titlebar/sticky_focus_inactive.png"
  theme.titlebar_sticky_button_normal_active = theme.dir .. "default/titlebar/sticky_normal_active.png"
  theme.titlebar_sticky_button_focus_active = theme.dir .. "default/titlebar/sticky_focus_active.png"

  theme.titlebar_floating_button_normal_inactive = theme.dir .. "default/titlebar/floating_normal_inactive.png"
  theme.titlebar_floating_button_focus_inactive = theme.dir .. "default/titlebar/floating_focus_inactive.png"
  theme.titlebar_floating_button_normal_active = theme.dir .. "default/titlebar/floating_normal_active.png"
  theme.titlebar_floating_button_focus_active = theme.dir .. "default/titlebar/floating_focus_active.png"

  theme.titlebar_maximized_button_normal_inactive = theme.dir .. "default/titlebar/maximized_normal_inactive.png"
  theme.titlebar_maximized_button_focus_inactive = theme.dir .. "default/titlebar/maximized_focus_inactive.png"
  theme.titlebar_maximized_button_normal_active = theme.dir .. "default/titlebar/maximized_normal_active.png"
  theme.titlebar_maximized_button_focus_active = theme.dir .. "default/titlebar/maximized_focus_active.png"

  -- You can use your own layout icons like this:
  theme.layout_fairh = theme.dir .. "default/layouts/fairhw.png"
  theme.layout_fairv = theme.dir .. "default/layouts/fairvw.png"
  theme.layout_floating = theme.dir .. "default/layouts/floatingw.png"
  theme.layout_magnifier = theme.dir .. "default/layouts/magnifierw.png"
  theme.layout_max = theme.dir .. "default/layouts/maxw.png"
  theme.layout_fullscreen = theme.dir .. "default/layouts/fullscreenw.png"
  theme.layout_tilebottom = theme.dir .. "default/layouts/tilebottomw.png"
  theme.layout_tileleft = theme.dir .. "default/layouts/tileleftw.png"
  theme.layout_tile = theme.dir .. "default/layouts/tilew.png"
  theme.layout_tiletop = theme.dir .. "default/layouts/tiletopw.png"
  theme.layout_spiral = theme.dir .. "default/layouts/spiralw.png"
  theme.layout_dwindle = theme.dir .. "default/layouts/dwindlew.png"
  theme.layout_cornernw = theme.dir .. "default/layouts/cornernww.png"
  theme.layout_cornerne = theme.dir .. "default/layouts/cornernew.png"
  theme.layout_cornersw = theme.dir .. "default/layouts/cornersww.png"
  theme.layout_cornerse = theme.dir .. "default/layouts/cornersew.png"

  -- Define the icon theme for application icons. If not set then the icons
  -- from /usr/share/icons and /usr/share/icons/hicolor will be used.
  theme.icon_theme = nil

  -- Set different colors for urgent notifications.
  rnotification.connect_signal("request::rules", function()
    rnotification.append_rule({
      rule = { urgency = "critical" },
      properties = { bg = "#ff0000", fg = "#ffffff" },
    })
  end)

  return theme
end
