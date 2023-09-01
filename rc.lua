pcall(require, "luarocks.loader")

local themes = require("themes")
local config = require("config")
local keys = require("config.keybindings")
local modules = require("modules")

themes({ "default", "surreal-theme", "bling", "my-theme" })

local cfg = config()
keys()
modules(cfg)
