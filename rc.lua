-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- FENNEL TIME BABY
local fennel = require("./fennel").install()
fennel.path = fennel.path .. ";.config/awesome/?.fnl"
require("main")
