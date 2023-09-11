local awful = require('awful')
awful.util.shell = 'sh'

return function()
  require('config.rules')
  require('config.signals')
  return {
    tags = require('config.tags'),
  }
end
