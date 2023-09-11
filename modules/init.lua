require('modules.auto-start')

return function(cfg)
  require('modules.notifications')
  require('modules.dynamic-wallpaper')
  require('modules.titlebar')
  require('modules.menu')
  require('modules.exit-screen')
  require('modules.screen')(cfg.tags)
end
