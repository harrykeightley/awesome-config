local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local icons_path = gfs.get_configuration_dir() .. "/themes/hydrangea/icons/"

local theme = {}

-- Rose pine Theme
local base = "#191724"
local surface = "#1f1d2e"
local overlay = "#26233a"
local muted = "#6e6a86"
local subtle = "#908caa"
local text = "#e0def4"
local love = "#eb6f92"
local gold = "#f6c177"
local rose = "#ebbcba"
local pine = "#31748f"
local foam = "#9ccfd8"
local iris = "#c4a7e7"
local highlight_low = "#21202e"
local highlight_med = "#403d52"
local highlight_high = "#524f67"

-- theme.font = "Cartograph CF Regular 8"
-- theme.font_name = "Cartograph CF Regular "
theme.font = "JetbrainsMono NFM Regular 10"
theme.font_name = "JetbrainsMono NFM Regular "

theme.bg_normal = base
theme.bg_focus = overlay
theme.bg_subtle = subtle
theme.bg_urgent = surface
theme.bg_minimize = surface
theme.bg_dark = surface
theme.bg_systray = theme.bg_normal

theme.fg_normal = text
theme.fg_focus = gold
theme.fg_urgent = love
theme.fg_minimize = muted

theme.useless_gap = dpi(10)
theme.border_width = dpi(0)
theme.border_color_normal = theme.bg_subtle
theme.border_color_active = theme.bg_focus
theme.border_color_marked = theme.bg_subtle

theme.green = pine
theme.warn = rose
theme.critical = love

theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_urgent

theme.taglist_fg_empty = theme.fg_minimize

theme.slider_active_color = theme.fg_minimize
theme.slider_handle_color = theme.fg_minimize

theme.control_button_active_bg = theme.bg_focus
theme.control_button_active_fg = theme.fg_normal
theme.control_button_normal_bg = theme.bg_normal
theme.control_button_normal_fg = theme.fg_normal

theme.notification_icon = icons_path .. "notification.png"
theme.notification_spacing = 10

theme.music_default_icon = icons_path .. "music.svg"
theme.music_prev_icon = icons_path .. "prev.svg"
theme.music_next_icon = icons_path .. "next.svg"
theme.music_play_icon = icons_path .. "play.svg"
theme.music_pause_icon = icons_path .. "pause.svg"

theme.menu_fg_normal = theme.fg_minimize
theme.menu_fg_focus = theme.fg_normal
theme.menu_submenu_icon = gears.color.recolor_image(icons_path .. "submenu.svg", theme.fg_subtle)
theme.menu_height = dpi(30)
theme.menu_width = dpi(130)
theme.menu_border_width = dpi(10)
theme.menu_border_color = "#00000000"

theme.layout_floating = gears.color.recolor_image(themes_path .. "default/layouts/floatingw.png", theme.fg_normal)
theme.layout_tile = gears.color.recolor_image(themes_path .. "default/layouts/tilew.png", theme.fg_normal)
theme.layout_max = gears.color.recolor_image(themes_path .. "default/layouts/maxw.png", theme.fg_normal)
theme.layout_tilebottom = gears.color.recolor_image(themes_path .. "default/layouts/tilebottomw.png", theme.fg_normal)
theme.layout_spiral = gears.color.recolor_image(themes_path .. "default/layouts/spiralw.png", theme.fg_normal)

theme.tag_preview_widget_border_radius = 0
theme.tag_preview_client_border_radius = 0
theme.tag_preview_client_opacity = 0.5
theme.tag_preview_client_bg = theme.bg_normal
theme.tag_preview_client_border_color = theme.bg_subtle
theme.tag_preview_client_border_width = 3
theme.tag_preview_widget_bg = theme.bg_dark
theme.tag_preview_widget_border_color = theme.bg_focus
theme.tag_preview_widget_border_width = 2
theme.tag_preview_widget_margin = 10

theme.task_preview_widget_border_radius = 0
theme.task_preview_widget_bg = theme.bg_dark
theme.task_preview_widget_border_color = theme.bg_focus
theme.task_preview_widget_border_width = 3
theme.task_preview_widget_margin = 15

theme.tabbar_radius = 0
theme.tabbar_style = "default"
theme.tabbar_size = 40
theme.tabbar_position = "top"

theme.icon_theme = nil

return theme
