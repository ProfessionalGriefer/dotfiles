local wezterm = require("wezterm")

local config = wezterm.config_builder()
config.font = wezterm.font("FiraCode Nerd Font Mono")
config.font_size = 19

config.enable_tab_bar = false
config.window_decorations = "RESIZE"

config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

return config
