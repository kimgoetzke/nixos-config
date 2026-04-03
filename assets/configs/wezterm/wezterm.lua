local wezterm = require("wezterm")
local config = wezterm.config_builder()
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

-- Set color scheme first
config.color_scheme = "stylix"

-- Other basics
config.font = wezterm.font_with_fallback {
  "JetBrainsMono Nerd Font",
  "Noto Color Emoji",
}
config.font_size = 16
config.window_background_opacity = 0.3

local islands_dark_tabline_theme = {
  foreground = "#DFE1E5",
  background = "#191A1C",
  cursor = {
    fg = "#191A1C",
    bg = "#2B2D30",
    border = "#CED0D6",
  },
  ansi = {
    "#191A1C",
    "#F75464",
    "#6AAB73",
    "#E0BB65",
    "#56A8F5",
    "#C77DBB",
    "#2AACB8",
    "#CED0D6",
  },
  brights = {
    "#2B2D30",
    "#F75464",
    "#6AAB73",
    "#E0BB65",
    "#56A8F5",
    "#C77DBB",
    "#2AACB8",
    "#DFE1E5",
  },
  tab_bar = {
    inactive_tab = {
      bg_color = "#191A1C",
      fg_color = "#CED0D6",
    },
  },
}

-- Colours
config.window_frame = {
  active_titlebar_bg = "#7A7E85",
  active_titlebar_fg = "#DFE1E5",
  active_titlebar_border_bottom = "#7A7E85",
  border_left_color = "#2B2D30",
  border_right_color = "#2B2D30",
  border_bottom_color = "#2B2D30",
  border_top_color = "#2B2D30",
  button_bg = "#2B2D30",
  button_fg = "#DFE1E5",
  button_hover_bg = "#DFE1E5",
  button_hover_fg = "#7A7E85",
  inactive_titlebar_bg = "#2B2D30",
  inactive_titlebar_fg = "#DFE1E5",
  inactive_titlebar_border_bottom = "#7A7E85",
}

config.colors = {
  tab_bar = {
    --     background = "#56A8F5", -- If tabline is not used
    background = "#191A1C",
    inactive_tab_edge = "#2B2D30",
    active_tab = {
      bg_color = "#E0BB65",
      fg_color = "#191A1C",
    },
    inactive_tab = {
      bg_color = "#56A8F5",
      fg_color = "#DFE1E5",
    },
    inactive_tab_hover = {
      bg_color = "#DFE1E5",
      fg_color = "#191A1C",
    },
    new_tab = {
      bg_color = "#191A1C",
      fg_color = "#DFE1E5",
    },
    new_tab_hover = {
      bg_color = "#DFE1E5",
      fg_color = "#191A1C",
    },
  },
}

config.command_palette_bg_color = "#56A8F5"
config.command_palette_fg_color = "#DFE1E5"
config.command_palette_font_size = 14

-- General settings
config.default_prog = { 'zsh', '--login' }
config.enable_wayland = false
config.cursor_blink_rate = 800
config.colors.cursor_border = '#CED0D6'

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

-- Tabline bar
tabline.setup({
  options = {
    theme = islands_dark_tabline_theme,
    theme_overrides = {
      normal_mode = {
        a = { fg = "#191A1C", bg = "#56A8F5" },
        b = { fg = "#56A8F5", bg = "#2B2D30" },
        c = { fg = "#DFE1E5", bg = "#191A1C" },
      },
      copy_mode = {
        a = { fg = "#191A1C", bg = "#E0BB65" },
        b = { fg = "#E0BB65", bg = "#2B2D30" },
        c = { fg = "#DFE1E5", bg = "#191A1C" },
      },
      search_mode = {
        a = { fg = "#191A1C", bg = "#6AAB73" },
        b = { fg = "#6AAB73", bg = "#2B2D30" },
        c = { fg = "#DFE1E5", bg = "#191A1C" },
      },
      tab = {
        active = { fg = "#E0BB65", bg = "#2B2D30" },
        inactive = { fg = "#CED0D6", bg = "#191A1C" },
        inactive_hover = { fg = "#C77DBB", bg = "#2B2D30" },
      },
    },
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

-- Remove padding and transparent background while Posting or Neovim are running
wezterm.on("update-right-status", function(window, pane)
  local process_name = pane:get_foreground_process_name() or ""
  local should_remove_padding = process_name:match("python") or process_name:match("nvim")
  if should_remove_padding then
    window:set_config_overrides({
      window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
      window_background_opacity = 1,
    })
  else
    window:set_config_overrides({
      window_padding = { left = 10, right = 10, top = 10, bottom = 10 },
      window_background_opacity = 0.3,
    })
  end
end)

return config
