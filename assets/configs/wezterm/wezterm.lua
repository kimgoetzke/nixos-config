local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Modified Stylix color scheme
config = {
    color_scheme = "stylix",
    font = wezterm.font_with_fallback {
        "JetBrainsMono Nerd Font",
        "Noto Color Emoji",
    },
    font_size = 16,
    window_background_opacity = 0.600000,

    window_frame = {
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
    },
    colors = {
      tab_bar = {
        background = "#3b4252",
        inactive_tab_edge = "#3b4252",
        active_tab = {
          bg_color = "#2e3440",
          fg_color = "#ebcb8b",
        },
        inactive_tab = {
          bg_color = "#4c566a",
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
    },
    command_palette_bg_color = "#3b4252",
    command_palette_fg_color = "#e5e9f0",
    command_palette_font_size = 10,
}

-- General
config.default_prog = { 'zsh', '--login' }
config.enable_wayland = false
config.front_end = 'WebGpu'
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

-- Keys
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
        action = wezterm.action.CloseCurrentTab { confirm=true },
    },
    {
        key = 'w',
        mods = 'SHIFT|CTRL|ALT',
        action = wezterm.action.CloseCurrentPane { confirm=true },
    },
    {
        key = 'v',
        mods = 'SHIFT|CTRL|ALT',
        action = wezterm.action.SplitVertical{ domain =  'CurrentPaneDomain' },
    },
    {
        key = 'h',
        mods = 'SHIFT|CTRL|ALT',
        action = wezterm.action.SplitHorizontal{ domain =  'CurrentPaneDomain' },
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
}

return config