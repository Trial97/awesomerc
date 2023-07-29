return {
    terminal        = 'kitty',
    web_browser     = 'firefox',
    text_editor     = 'vim',
    ide             = 'code',
    git             = 'smerge',
    file_manager    = 'thunar',
    multimedia      = 'vlc',
    power_manager   = 'lxqt-config-powermanagement',
    lock            = 'lock',
    full_screenshot = 'snap full',
    area_screenshot = 'snap area',
    appmenu         = 'rofi -dpi ' .. math.ceil(screen.primary.dpi) .. ' -show drun -theme .config/rofi2/rofi.rasi',
    globalSearch    = 'rofi -dpi ' ..
        math.ceil(screen.primary.dpi) ..
        ' -show "Global Search" -modi "Global Search":.config/rofi2/rofi-spotlight.sh -theme .config/rofi2/rofi.rasi',
    defaultRofi     = 'rofi -show drun'
}
