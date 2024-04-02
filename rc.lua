-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- -- Standard awesome library
-- local gears = require("gears")
local awful = require("awful")
--
-- RC = {}

-- -- a variable needed in statusbar (helper)
-- RC.launcher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = RC.mainmenu })
--
-- -- Menubar configuration
-- -- Set the terminal for applications that require it
-- menubar.utils.terminal = RC.vars.terminal
--
--
mykeyboardlayout = awful.widget.keyboardlayout()
--
-- Basic numbers along the bottom
-- require("deco.statusbar")
--
--
-- require("main.signals")
-- require("deco.styling")
--
-- require("main.post-config")
--
-- FENNEL TIME BABY
local fennel = require("./fennel").install()
fennel.path = fennel.path .. ";.config/awesome/?.fnl"
require("main")
