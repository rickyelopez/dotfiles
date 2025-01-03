local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.audible_bell = "Disabled"

config.color_scheme = "Gruvbox dark, medium (base16)"
config.font = wezterm.font("BlexMono Nerd Font Mono", { weight = "Medium" })
config.font_size = 11.0

config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

config.window_padding = {
  left = 1,
  right = 1,
  top = 0,
  bottom = 0,
}

config.front_end = "WebGpu"
config.set_environment_variables = {
  TERMINFO_DIRS = "~/.nix-profile/share/terminfo",
}
config.term = "wezterm"

return config
