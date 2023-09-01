local nice = require("extra.nice")
nice({
  titlebar_items = {
    right = { "minimize", "maximize", "close" },
    middle = "title",
    left = { "sticky", "ontop", "floating" },
  },
  titlebar_height = 21,
  button_size = 13,
  titlebar_font = "Sans 8",
  expand = "inside",
})
