local wezterm = require("wezterm")
local config = wezterm.config_builder()
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

-- Set color scheme first
config.color_scheme = "stylix"

-- tabline.apply_to_config(config)

config.font = wezterm.font_with_fallback {
  "JetBrainsMono Nerd Font",
  "Noto Color Emoji",
}

config.font_size = 16
config.window_background_opacity = 0.3

config.window_frame = {
  active_titlebar_bg = "#4c566a",
  active_titlebar_fg = "#e5e9f0",
  active_titlebar_border_bottom = "#4c566a",
  border_left_color = "#3b4252",
  border_right_color = "#3b4252",
  border_bottom_color = "#3b4252",
  border_top_color = "#3b4252",
  button_bg = "#3b4252",
  button_fg = "#e5e9f0",
  button_hover_bg = "#e5e9f0",
  button_hover_fg = "#4c566a",
  inactive_titlebar_bg = "#3b4252",
  inactive_titlebar_fg = "#e5e9f0",
  inactive_titlebar_border_bottom = "#4c566a",
}

config.colors = {
  tab_bar = {
    --     background = "#5e81ac", -- If tabline is not used
    background = "#2E3440",
    inactive_tab_edge = "#3b4252",
    active_tab = {
      bg_color = "#ebcb8b",
      fg_color = "#2e3440",
    },
    inactive_tab = {
      bg_color = "#5e81ac",
      fg_color = "#e5e9f0",
    },
    inactive_tab_hover = {
      bg_color = "#e5e9f0",
      fg_color = "#2e3440",
    },
    new_tab = {
      bg_color = "#2e3440",
      fg_color = "#e5e9f0",
    },
    new_tab_hover = {
      bg_color = "#e5e9f0",
      fg_color = "#2e3440",
    },
  },
}

config.command_palette_bg_color = "#5e81ac"
config.command_palette_fg_color = "#e5e9f0"
config.command_palette_font_size = 14

-- General settings
config.default_prog = { 'zsh', '--login' }
config.enable_wayland = false
config.cursor_blink_rate = 800
config.colors.cursor_border = '#d8dee9'

-- Background
-- config.window_background_gradient = {
--     -- "Vertical" or "Horizontal" or { Linear = { angle = -45.0 } },
--     -- orientation = 'Vertical',
--     -- orientation = { Linear = { angle = -45.0 } },
--     orientation = {
--         Radial = {
--             cx = 0.75,
--             cy = 0.35,
--             radius = 1.25,
--         },
--       },
--
--     colors = {
--         '#253344',
--         '#242933',
--     },
--
--     -- preset = "Viridis",
--
--     -- "Linear", "Basis" and "CatmullRom" as supported.
--     interpolation = 'Linear',
--
--     -- "Rgb", "LinearRgb", "Hsv" and "Oklab" are supported.
--     blend = 'Rgb',
--
--     -- noise = 64,
--     -- segment_size = 3,
--     -- segment_smoothness = 1.0,
-- }

-- Tabs
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false

-- Panes
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.8,
}

-- Keybindings
config.keys = {
  {
    key = '"',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.ActivateTab(1),
  },
  {
    key = '£',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.ActivateTab(2),
  },
  {
    key = 'w',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  {
    key = 'w',
    mods = 'SHIFT|CTRL|ALT',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    key = 'v',
    mods = 'SHIFT|CTRL|ALT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'h',
    mods = 'SHIFT|CTRL|ALT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'a',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.ActivatePaneDirection 'Next',
  },
  {
    key = 's',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.ActivatePaneDirection 'Prev',
  },
  {
    key = 'p',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateCommandPalette,
  },
  {
    key = 'l',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DisableDefaultAssignment,
  },
}

tabline.setup({
  options = {
    theme = "nord",
  },
  sections = {
    tabline_a = { 'mode' },
    tabline_b = {},
    tabline_c = { ' ' },
    tab_active = { 'index', { 'process', padding = { left = 0, right = 1 }, max_length = 20, } },
    tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
    tabline_x = {},
    tabline_y = { 'cpu' },
    tabline_z = { 'domain' },
  },
})

-- Remove padding when nvim is running
wezterm.on("update-right-status", function(window, pane)
  local process_name = pane:get_foreground_process_name() or ""
  if process_name:match("nvim") then
    window:set_config_overrides({
      window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
    })
  else
    window:set_config_overrides({
      window_padding = { left = 10, right = 10, top = 10, bottom = 10 },
    })
  end
end)

return config
