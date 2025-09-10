{
  cfg,
    lib,
}:
with lib;
with builtins; ''
local wezterm = require 'wezterm'

local config = wezterm.config_builder()

  config.colors = {
    foreground = '#f7f7f7',
    background = '#0e0c0a',

    cursor_bg = '#fdffd1',
    cursor_fg = '#0e0c0a',
    cursor_border = "#fdffd1",

    selection_fg = '#191613',
    selection_bg = '#f7f7f7',

    ansi = {
      "#0e0c0a",
      "#ff909d",
      "#d3ffdb",
      "#fdffd1",
      "#aec1ff",
      "#ddb6ff",
      "#c9fafa",
      "#f7f7f7",
    },

    brights = {
      "#000000",
      "#ff6571",
      "#89ffcb",
      "#ffff99",
      "#7d9eff",
      "#aa93ff",
      "#95fbfb",
      "#ffffff",
    },
  }

config.font = wezterm.font_with_fallback {
  'Berkeley Mono SemiCondensed',
    'Hack Nerd Font',
}

config.font_size = ${toString cfg.emulator.font_size}
config.line_height = ${toString cfg.emulator.line_height}
config.enable_tab_bar = false
config.window_padding = {
  left = ${toString (elemAt cfg.emulator.padding 0)},
  right = ${toString (elemAt cfg.emulator.padding 1)},
  top = ${toString (elemAt cfg.emulator.padding 2)},
  bottom = ${toString (elemAt cfg.emulator.padding 3)},
}

config.front_end = "OpenGL"

config.default_prog = { "tmux", "new-session", "-A", "-s", "scripting" }

return config
''
