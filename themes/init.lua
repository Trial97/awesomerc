local beautiful = require('beautiful')

local function loadThemes(themeNames)
  local theme = {}
  for _, themeName in ipairs(themeNames) do
    theme = require('themes.' .. themeName)(theme)
  end
  return theme
end

return function(themeNames)
  beautiful.init(loadThemes(themeNames))
end
