{
  pkgs,
  config,
  lib,
  userSettings,
  ...
}: {
  options = {
    hyprland-hyprpanel.enable = lib.mkEnableOption "Enable HyperPanel, a basic bar/panel for Hyprland";
  };

  config = lib.mkIf config.hyprland-hyprpanel.enable {
    # TODO: Move this to another module as Thunar needs it too
    gtk.iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    home.file.".cache/ags/hyprpanel/options.json" = {
      text = ''
        {
          "bar.customModules.updates.pollingInterval": 1440000,
          "theme.font.size": "1.1rem",
          "theme.font.weight": 400,
          "theme.osd.scaling": 100,
          "theme.bar.scaling": 100,
          "theme.bar.menus.background": "#2e3440",
          "theme.bar.background": "#2e3440",
          "theme.bar.buttons.media.icon": "#3b4252",
          "theme.bar.buttons.media.text": "#88c0d0",
          "theme.bar.buttons.icon": "#242438",
          "theme.bar.buttons.text": "#88c0d0",
          "theme.bar.buttons.hover": "#434c53",
          "theme.bar.buttons.background": "#3b4252",
          "theme.bar.menus.text": "#d8dee9",
          "theme.bar.menus.border.color": "#434c53",
          "theme.bar.buttons.media.background": "#3b4252",
          "theme.bar.menus.menu.volume.text": "#d8dee9",
          "theme.bar.menus.menu.volume.card.color": "#3b4252",
          "theme.bar.menus.menu.volume.label.color": "#81a1c1",
          "theme.bar.menus.popover.text": "#88c0d0",
          "theme.bar.menus.popover.background": "#2e3440",
          "theme.bar.menus.menu.dashboard.powermenu.shutdown": "#8fbcbb",
          "theme.bar.menus.menu.dashboard.powermenu.confirmation.deny": "#8fbcbb",
          "theme.bar.menus.menu.dashboard.powermenu.confirmation.confirm": "#8fbcbb",
          "theme.bar.menus.menu.dashboard.powermenu.confirmation.button_text": "#2e3440",
          "theme.bar.menus.menu.dashboard.powermenu.confirmation.body": "#d8dee9",
          "theme.bar.menus.menu.dashboard.powermenu.confirmation.label": "#88c0d0",
          "theme.bar.menus.menu.dashboard.powermenu.confirmation.border": "#434c53",
          "theme.bar.menus.menu.dashboard.powermenu.confirmation.background": "#2e3440",
          "theme.bar.menus.menu.dashboard.powermenu.confirmation.card": "#3b4252",
          "theme.bar.menus.menu.notifications.switch.puck": "#434c53",
          "theme.bar.menus.menu.notifications.switch.disabled": "#434c53",
          "theme.bar.menus.menu.notifications.switch.enabled": "#88c0d0",
          "theme.bar.menus.menu.notifications.clear": "#8fbcbb",
          "theme.bar.menus.menu.notifications.switch_divider": "#434c53",
          "theme.bar.menus.menu.notifications.border": "#434c53",
          "theme.bar.menus.menu.notifications.card": "#3b4252",
          "theme.bar.menus.menu.notifications.background": "#2e3440",
          "theme.bar.menus.menu.notifications.no_notifications_label": "#434c53",
          "theme.bar.menus.menu.notifications.label": "#88c0d0",
          "theme.bar.menus.menu.dashboard.monitors.disk.label": "#8fbcbb",
          "theme.bar.menus.menu.dashboard.monitors.disk.bar": "#8fbcbb",
          "theme.bar.menus.menu.dashboard.monitors.disk.icon": "#8fbcbb",
          "theme.bar.menus.menu.dashboard.monitors.gpu.label": "#8fbcbb",
          "theme.bar.menus.menu.dashboard.monitors.gpu.bar": "#8fbcbb",
          "theme.bar.menus.menu.dashboard.monitors.gpu.icon": "#8fbcbb",
          "theme.bar.menus.menu.dashboard.monitors.ram.label": "#81a1c1",
          "theme.bar.menus.menu.dashboard.monitors.ram.bar": "#81a1c1",
          "theme.bar.menus.menu.dashboard.monitors.ram.icon": "#81a1c1",
          "theme.bar.menus.menu.dashboard.monitors.cpu.label": "#81a1c1",
          "theme.bar.menus.menu.dashboard.monitors.cpu.bar": "#81a1c1",
          "theme.bar.menus.menu.dashboard.monitors.cpu.icon": "#81a1c1",
          "theme.bar.menus.menu.dashboard.monitors.bar_background": "#434c53",
          "theme.bar.menus.menu.dashboard.directories.right.bottom.color": "#88c0d0",
          "theme.bar.menus.menu.dashboard.directories.right.middle.color": "#88c0d0",
          "theme.bar.menus.menu.dashboard.directories.right.top.color": "#8fbcbb",
          "theme.bar.menus.menu.dashboard.directories.left.bottom.color": "#81a1c1",
          "theme.bar.menus.menu.dashboard.directories.left.middle.color": "#81a1c1",
          "theme.bar.menus.menu.dashboard.directories.left.top.color": "#8fbcbb",
          "theme.bar.menus.menu.dashboard.controls.input.text": "#2e3440",
          "theme.bar.menus.menu.dashboard.controls.input.background": "#8fbcbb",
          "theme.bar.menus.menu.dashboard.controls.volume.text": "#2e3440",
          "theme.bar.menus.menu.dashboard.controls.volume.background": "#81a1c1",
          "theme.bar.menus.menu.dashboard.controls.notifications.text": "#2e3440",
          "theme.bar.menus.menu.dashboard.controls.notifications.background": "#81a1c1",
          "theme.bar.menus.menu.dashboard.controls.bluetooth.text": "#2e3440",
          "theme.bar.menus.menu.dashboard.controls.bluetooth.background": "#88c0d0",
          "theme.bar.menus.menu.dashboard.controls.wifi.text": "#2e3440",
          "theme.bar.menus.menu.dashboard.controls.wifi.background": "#88c0d0",
          "theme.bar.menus.menu.dashboard.controls.disabled": "#434c53",
          "theme.bar.menus.menu.dashboard.shortcuts.recording": "#8fbcbb",
          "theme.bar.menus.menu.dashboard.shortcuts.text": "#2e3440",
          "theme.bar.menus.menu.dashboard.shortcuts.background": "#88c0d0",
          "theme.bar.menus.menu.dashboard.powermenu.sleep": "#88c0d0",
          "theme.bar.menus.menu.dashboard.powermenu.logout": "#8fbcbb",
          "theme.bar.menus.menu.dashboard.powermenu.restart": "#81a1c1",
          "theme.bar.menus.menu.dashboard.profile.name": "#8fbcbb",
          "theme.bar.menus.menu.dashboard.border.color": "#434c53",
          "theme.bar.menus.menu.dashboard.background.color": "#2e3440",
          "theme.bar.menus.menu.dashboard.card.color": "#3b4252",
          "theme.bar.menus.menu.clock.weather.hourly.temperature": "#8fbcbb",
          "theme.bar.menus.menu.clock.weather.hourly.icon": "#8fbcbb",
          "theme.bar.menus.menu.clock.weather.hourly.time": "#8fbcbb",
          "theme.bar.menus.menu.clock.weather.thermometer.extremelycold": "#88c0d0",
          "theme.bar.menus.menu.clock.weather.thermometer.cold": "#88c0d0",
          "theme.bar.menus.menu.clock.weather.thermometer.moderate": "#88c0d0",
          "theme.bar.menus.menu.clock.weather.thermometer.hot": "#81a1c1",
          "theme.bar.menus.menu.clock.weather.thermometer.extremelyhot": "#8fbcbb",
          "theme.bar.menus.menu.clock.weather.stats": "#8fbcbb",
          "theme.bar.menus.menu.clock.weather.status": "#8fbcbb",
          "theme.bar.menus.menu.clock.weather.temperature": "#d8dee9",
          "theme.bar.menus.menu.clock.weather.icon": "#8fbcbb",
          "theme.bar.menus.menu.clock.calendar.contextdays": "#434c53",
          "theme.bar.menus.menu.clock.calendar.days": "#d8dee9",
          "theme.bar.menus.menu.clock.calendar.currentday": "#8fbcbb",
          "theme.bar.menus.menu.clock.calendar.paginator": "#8fbcbb",
          "theme.bar.menus.menu.clock.calendar.weekdays": "#8fbcbb",
          "theme.bar.menus.menu.clock.calendar.yearmonth": "#8fbcbb",
          "theme.bar.menus.menu.clock.time.timeperiod": "#8fbcbb",
          "theme.bar.menus.menu.clock.time.time": "#8fbcbb",
          "theme.bar.menus.menu.clock.text": "#d8dee9",
          "theme.bar.menus.menu.clock.border.color": "#434c53",
          "theme.bar.menus.menu.clock.background.color": "#2e3440",
          "theme.bar.menus.menu.clock.card.color": "#3b4252",
          "theme.bar.menus.menu.battery.slider.puck": "#4c566a",
          "theme.bar.menus.menu.battery.slider.backgroundhover": "#434c53",
          "theme.bar.menus.menu.battery.slider.background": "#434c53",
          "theme.bar.menus.menu.battery.slider.primary": "#81a1c1",
          "theme.bar.menus.menu.battery.icons.active": "#81a1c1",
          "theme.bar.menus.menu.battery.icons.passive": "#5e81ac",
          "theme.bar.menus.menu.battery.listitems.active": "#81a1c1",
          "theme.bar.menus.menu.battery.listitems.passive": "#d8dee9",
          "theme.bar.menus.menu.battery.text": "#d8dee9",
          "theme.bar.menus.menu.battery.label.color": "#81a1c1",
          "theme.bar.menus.menu.battery.border.color": "#434c53",
          "theme.bar.menus.menu.battery.background.color": "#2e3440",
          "theme.bar.menus.menu.battery.card.color": "#3b4252",
          "theme.bar.menus.menu.systray.dropdownmenu.divider": "#3b4252",
          "theme.bar.menus.menu.systray.dropdownmenu.text": "#d8dee9",
          "theme.bar.menus.menu.systray.dropdownmenu.background": "#2e3440",
          "theme.bar.menus.menu.bluetooth.iconbutton.active": "#88c0d0",
          "theme.bar.menus.menu.bluetooth.iconbutton.passive": "#d8dee9",
          "theme.bar.menus.menu.bluetooth.icons.active": "#88c0d0",
          "theme.bar.menus.menu.bluetooth.icons.passive": "#5e81ac",
          "theme.bar.menus.menu.bluetooth.listitems.active": "#88c0d0",
          "theme.bar.menus.menu.bluetooth.listitems.passive": "#d8dee9",
          "theme.bar.menus.menu.bluetooth.switch.puck": "#434c53",
          "theme.bar.menus.menu.bluetooth.switch.disabled": "#434c53",
          "theme.bar.menus.menu.bluetooth.switch.enabled": "#88c0d0",
          "theme.bar.menus.menu.bluetooth.switch_divider": "#434c53",
          "theme.bar.menus.menu.bluetooth.status": "#4c566a",
          "theme.bar.menus.menu.bluetooth.text": "#d8dee9",
          "theme.bar.menus.menu.bluetooth.label.color": "#88c0d0",
          "theme.bar.menus.menu.bluetooth.border.color": "#434c53",
          "theme.bar.menus.menu.bluetooth.background.color": "#2e3440",
          "theme.bar.menus.menu.bluetooth.card.color": "#3b4252",
          "theme.bar.menus.menu.network.iconbuttons.active": "#88c0d0",
          "theme.bar.menus.menu.network.iconbuttons.passive": "#d8dee9",
          "theme.bar.menus.menu.network.icons.active": "#88c0d0",
          "theme.bar.menus.menu.network.icons.passive": "#5e81ac",
          "theme.bar.menus.menu.network.listitems.active": "#88c0d0",
          "theme.bar.menus.menu.network.listitems.passive": "#d8dee9",
          "theme.bar.menus.menu.network.status.color": "#4c566a",
          "theme.bar.menus.menu.network.text": "#d8dee9",
          "theme.bar.menus.menu.network.label.color": "#88c0d0",
          "theme.bar.menus.menu.network.border.color": "#434c53",
          "theme.bar.menus.menu.network.background.color": "#2e3440",
          "theme.bar.menus.menu.network.card.color": "#3b4252",
          "theme.bar.menus.menu.volume.input_slider.puck": "#434c53",
          "theme.bar.menus.menu.volume.input_slider.backgroundhover": "#434c53",
          "theme.bar.menus.menu.volume.input_slider.background": "#434c53",
          "theme.bar.menus.menu.volume.input_slider.primary": "#81a1c1",
          "theme.bar.menus.menu.volume.audio_slider.puck": "#434c53",
          "theme.bar.menus.menu.volume.audio_slider.backgroundhover": "#434c53",
          "theme.bar.menus.menu.volume.audio_slider.background": "#434c53",
          "theme.bar.menus.menu.volume.audio_slider.primary": "#81a1c1",
          "theme.bar.menus.menu.volume.icons.active": "#81a1c1",
          "theme.bar.menus.menu.volume.icons.passive": "#5e81ac",
          "theme.bar.menus.menu.volume.iconbutton.active": "#81a1c1",
          "theme.bar.menus.menu.volume.iconbutton.passive": "#d8dee9",
          "theme.bar.menus.menu.volume.listitems.active": "#81a1c1",
          "theme.bar.menus.menu.volume.listitems.passive": "#d8dee9",
          "theme.bar.menus.menu.volume.border.color": "#434c53",
          "theme.bar.menus.menu.volume.background.color": "#2e3440",
          "theme.bar.menus.menu.media.slider.puck": "#4c566a",
          "theme.bar.menus.menu.media.slider.backgroundhover": "#434c53",
          "theme.bar.menus.menu.media.slider.background": "#434c53",
          "theme.bar.menus.menu.media.slider.primary": "#8fbcbb",
          "theme.bar.menus.menu.media.buttons.text": "#2e3440",
          "theme.bar.menus.menu.media.buttons.background": "#88c0d0",
          "theme.bar.menus.menu.media.buttons.enabled": "#8fbcbb",
          "theme.bar.menus.menu.media.buttons.inactive": "#434c53",
          "theme.bar.menus.menu.media.border.color": "#434c53",
          "theme.bar.menus.menu.media.background.color": "#2e3440",
          "theme.bar.menus.menu.media.album": "#8fbcbb",
          "theme.bar.menus.menu.media.artist": "#8fbcbb",
          "theme.bar.menus.menu.media.song": "#88c0d0",
          "theme.bar.menus.tooltip.text": "#d8dee9",
          "theme.bar.menus.tooltip.background": "#2e3440",
          "theme.bar.menus.dropdownmenu.divider": "#3b4252",
          "theme.bar.menus.dropdownmenu.text": "#d8dee9",
          "theme.bar.menus.dropdownmenu.background": "#2e3440",
          "theme.bar.menus.slider.puck": "#4c566a",
          "theme.bar.menus.slider.backgroundhover": "#434c53",
          "theme.bar.menus.slider.background": "#434c53",
          "theme.bar.menus.slider.primary": "#88c0d0",
          "theme.bar.menus.progressbar.background": "#434c53",
          "theme.bar.menus.progressbar.foreground": "#88c0d0",
          "theme.bar.menus.iconbuttons.active": "#88c0d0",
          "theme.bar.menus.iconbuttons.passive": "#d8dee9",
          "theme.bar.menus.buttons.text": "#2e3440",
          "theme.bar.menus.buttons.disabled": "#434c53",
          "theme.bar.menus.buttons.active": "#8fbcbb",
          "theme.bar.menus.buttons.default": "#88c0d0",
          "theme.bar.menus.switch.puck": "#434c53",
          "theme.bar.menus.switch.disabled": "#434c53",
          "theme.bar.menus.switch.enabled": "#88c0d0",
          "theme.bar.menus.icons.active": "#88c0d0",
          "theme.bar.menus.icons.passive": "#434c53",
          "theme.bar.menus.listitems.active": "#88c0d0",
          "theme.bar.menus.listitems.passive": "#d8dee9",
          "theme.bar.menus.label": "#88c0d0",
          "theme.bar.menus.feinttext": "#434c53",
          "theme.bar.menus.dimtext": "#6272a4",
          "theme.bar.menus.cards": "#3b4252",
          "theme.bar.buttons.notifications.total": "#88c0d0",
          "theme.bar.buttons.notifications.icon": "#3b4252",
          "theme.bar.buttons.notifications.background": "#3b4252",
          "theme.bar.buttons.clock.icon": "#3b4252",
          "theme.bar.buttons.clock.text": "#8fbcbb",
          "theme.bar.buttons.clock.background": "#3b4252",
          "theme.bar.buttons.battery.icon": "#3b4252",
          "theme.bar.buttons.battery.text": "#81a1c1",
          "theme.bar.buttons.battery.background": "#3b4252",
          "theme.bar.buttons.systray.background": "#3b4252",
          "theme.bar.buttons.bluetooth.icon": "#3b4252",
          "theme.bar.buttons.bluetooth.text": "#88c0d0",
          "theme.bar.buttons.bluetooth.background": "#3b4252",
          "theme.bar.buttons.network.icon": "#3b4252",
          "theme.bar.buttons.network.text": "#88c0d0",
          "theme.bar.buttons.network.background": "#3b4252",
          "theme.bar.buttons.volume.icon": "#3b4252",
          "theme.bar.buttons.volume.text": "#81a1c1",
          "theme.bar.buttons.volume.background": "#3b4252",
          "theme.bar.buttons.windowtitle.icon": "#3b4252",
          "theme.bar.buttons.windowtitle.text": "#8fbcbb",
          "theme.bar.buttons.windowtitle.background": "#3b4252",
          "theme.bar.buttons.workspaces.active": "#8fbcbb",
          "theme.bar.buttons.workspaces.occupied": "#81a1c1",
          "theme.bar.buttons.workspaces.available": "#88c0d0",
          "theme.bar.buttons.workspaces.hover": "#8fbcbb",
          "theme.bar.buttons.workspaces.background": "#3b4252",
          "theme.bar.buttons.dashboard.icon": "#3b4252",
          "theme.bar.buttons.dashboard.background": "#81a1c1",
          "theme.osd.label": "#88c0d0",
          "theme.osd.icon": "#2e3440",
          "theme.osd.bar_overflow_color": "#8fbcbb",
          "theme.osd.bar_empty_color": "#434c53",
          "theme.osd.bar_color": "#88c0d0",
          "theme.osd.icon_container": "#88c0d0",
          "theme.osd.bar_container": "#2e3440",
          "theme.notification.close_button.label": "#2e3440",
          "theme.notification.close_button.background": "#8fbcbb",
          "theme.notification.labelicon": "#88c0d0",
          "theme.notification.text": "#d8dee9",
          "theme.notification.time": "#4c566a",
          "theme.notification.border": "#434c53",
          "theme.notification.label": "#88c0d0",
          "theme.notification.actions.text": "#2e3440",
          "theme.notification.actions.background": "#88c0d0",
          "theme.notification.background": "#2e3440",
          "theme.bar.buttons.workspaces.numbered_active_highlighted_text_color": "#21252b",
          "theme.bar.buttons.workspaces.numbered_active_underline_color": "#ffffff",
          "theme.bar.menus.menu.media.card.color": "#3b4252",
          "theme.bar.menus.check_radio_button.background": "#2e3440",
          "theme.bar.menus.check_radio_button.active": "#88c0d0",
          "theme.bar.buttons.style": "split",
          "theme.bar.menus.menu.notifications.pager.button": "#88c0d0",
          "theme.bar.menus.menu.notifications.scrollbar.color": "#88c0d0",
          "theme.bar.menus.menu.notifications.pager.label": "#5e81ac",
          "theme.bar.menus.menu.notifications.pager.background": "#2e3440",
          "theme.bar.buttons.clock.icon_background": "#8fbcbb",
          "theme.bar.buttons.modules.ram.icon": "#21252b",
          "theme.bar.buttons.modules.storage.icon_background": "#8fbcbb",
          "theme.bar.menus.popover.border": "#2e3440",
          "theme.bar.buttons.volume.icon_background": "#81a1c1",
          "theme.bar.menus.menu.power.buttons.sleep.icon_background": "#88c0d0",
          "theme.bar.menus.menu.power.buttons.restart.text": "#81a1c1",
          "theme.bar.buttons.modules.updates.background": "#3b4252",
          "theme.bar.buttons.modules.storage.icon": "#21252b",
          "theme.bar.buttons.modules.netstat.background": "#3b4252",
          "theme.bar.buttons.modules.weather.icon": "#3b4252",
          "theme.bar.buttons.modules.netstat.text": "#8fbcbb",
          "theme.bar.buttons.modules.storage.background": "#3b4252",
          "theme.bar.buttons.modules.power.icon": "#21252b",
          "theme.bar.buttons.modules.storage.text": "#8fbcbb",
          "theme.bar.buttons.modules.cpu.background": "#3b4252",
          "theme.bar.menus.menu.power.border.color": "#434c53",
          "theme.bar.buttons.network.icon_background": "#88c0d0",
          "theme.bar.buttons.modules.power.icon_background": "#8fbcbb",
          "theme.bar.menus.menu.power.buttons.logout.icon": "#2e3440",
          "theme.bar.menus.menu.power.buttons.restart.icon_background": "#81a1c1",
          "theme.bar.menus.menu.power.buttons.restart.icon": "#2e3440",
          "theme.bar.buttons.modules.cpu.icon": "#21252b",
          "theme.bar.buttons.battery.icon_background": "#81a1c1",
          "theme.bar.buttons.modules.kbLayout.icon_background": "#88c0d0",
          "theme.bar.buttons.modules.weather.text": "#88c0d0",
          "theme.bar.menus.menu.power.buttons.shutdown.icon": "#2e3440",
          "theme.bar.menus.menu.power.buttons.sleep.text": "#88c0d0",
          "theme.bar.buttons.modules.weather.icon_background": "#88c0d0",
          "theme.bar.menus.menu.power.buttons.shutdown.background": "#3b4252",
          "theme.bar.buttons.media.icon_background": "#88c0d0",
          "theme.bar.menus.menu.power.buttons.logout.background": "#3b4252",
          "theme.bar.buttons.modules.kbLayout.icon": "#21252b",
          "theme.bar.buttons.modules.ram.icon_background": "#81a1c1",
          "theme.bar.menus.menu.power.buttons.shutdown.icon_background": "#8fbcbb",
          "theme.bar.menus.menu.power.buttons.shutdown.text": "#8fbcbb",
          "theme.bar.menus.menu.power.buttons.sleep.background": "#3b4252",
          "theme.bar.buttons.modules.ram.text": "#81a1c1",
          "theme.bar.menus.menu.power.buttons.logout.text": "#8fbcbb",
          "theme.bar.buttons.modules.updates.icon_background": "#88c0d0",
          "theme.bar.buttons.modules.kbLayout.background": "#3b4252",
          "theme.bar.buttons.modules.power.background": "#3b4252",
          "theme.bar.buttons.modules.weather.background": "#3b4252",
          "theme.bar.buttons.icon_background": "#88c0d0",
          "theme.bar.menus.menu.power.background.color": "#2e3440",
          "theme.bar.buttons.modules.ram.background": "#3b4252",
          "theme.bar.buttons.modules.netstat.icon": "#21252b",
          "theme.bar.buttons.windowtitle.icon_background": "#8fbcbb",
          "theme.bar.buttons.modules.cpu.icon_background": "#8fbcbb",
          "theme.bar.menus.menu.power.buttons.logout.icon_background": "#8fbcbb",
          "theme.bar.buttons.modules.updates.text": "#88c0d0",
          "theme.bar.menus.menu.power.buttons.sleep.icon": "#2e3440",
          "theme.bar.buttons.bluetooth.icon_background": "#88c0d0",
          "theme.bar.menus.menu.power.buttons.restart.background": "#3b4252",
          "theme.bar.buttons.modules.updates.icon": "#21252b",
          "theme.bar.buttons.modules.cpu.text": "#8fbcbb",
          "theme.bar.buttons.modules.netstat.icon_background": "#8fbcbb",
          "theme.bar.buttons.modules.kbLayout.text": "#88c0d0",
          "theme.bar.buttons.notifications.icon_background": "#88c0d0",
          "theme.bar.buttons.modules.power.border": "#8fbcbb",
          "theme.bar.buttons.modules.weather.border": "#88c0d0",
          "theme.bar.buttons.modules.updates.border": "#88c0d0",
          "theme.bar.buttons.modules.kbLayout.border": "#88c0d0",
          "theme.bar.buttons.modules.netstat.border": "#8fbcbb",
          "theme.bar.buttons.modules.storage.border": "#8fbcbb",
          "theme.bar.buttons.modules.cpu.border": "#8fbcbb",
          "theme.bar.buttons.modules.ram.border": "#81a1c1",
          "theme.bar.buttons.notifications.border": "#88c0d0",
          "theme.bar.buttons.clock.border": "#8fbcbb",
          "theme.bar.buttons.battery.border": "#81a1c1",
          "theme.bar.buttons.systray.border": "#434c53",
          "theme.bar.buttons.bluetooth.border": "#88c0d0",
          "theme.bar.buttons.network.border": "#88c0d0",
          "theme.bar.buttons.volume.border": "#81a1c1",
          "theme.bar.buttons.media.border": "#88c0d0",
          "theme.bar.buttons.windowtitle.border": "#8fbcbb",
          "theme.bar.buttons.workspaces.border": "#2e3440",
          "theme.bar.buttons.dashboard.border": "#81a1c1",
          "theme.bar.buttons.modules.submap.background": "#3b4252",
          "theme.bar.buttons.modules.submap.text": "#8fbcbb",
          "theme.bar.buttons.modules.submap.border": "#8fbcbb",
          "theme.bar.buttons.modules.submap.icon": "#21252b",
          "theme.bar.buttons.modules.submap.icon_background": "#8fbcbb",
          "theme.bar.menus.menu.network.switch.enabled": "#88c0d0",
          "theme.bar.menus.menu.network.switch.disabled": "#434c53",
          "theme.bar.menus.menu.network.switch.puck": "#434c53",
          "theme.bar.buttons.systray.customIcon": "#d8dee9",
          "theme.bar.border.color": "#88c0d0",
          "theme.bar.menus.menu.media.timestamp": "#d8dee9",
          "theme.bar.buttons.borderColor": "#88c0d0",
          "theme.bar.buttons.modules.hyprsunset.icon": "#21252b",
          "theme.bar.buttons.modules.hyprsunset.background": "#3b4252",
          "theme.bar.buttons.modules.hyprsunset.icon_background": "#81a1c1",
          "theme.bar.buttons.modules.hyprsunset.text": "#81a1c1",
          "theme.bar.buttons.modules.hyprsunset.border": "#81a1c1",
          "theme.bar.buttons.modules.hypridle.icon": "#21252b",
          "theme.bar.buttons.modules.hypridle.background": "#3b4252",
          "theme.bar.buttons.modules.hypridle.icon_background": "#8fbcbb",
          "theme.bar.buttons.modules.hypridle.text": "#8fbcbb",
          "theme.bar.buttons.modules.hypridle.border": "#8fbcbb",
          "theme.bar.floating": true,
          "theme.bar.buttons.enableBorders": false,
          "theme.bar.buttons.borderSize": "0.2em",
          "theme.bar.border.location": "none",
          "bar.workspaces.show_icons": true,
          "bar.workspaces.show_numbered": false,
          "bar.layouts": {
            "0": {
              "left": [
                "dashboard",
                "workspaces",
                "windowtitle"
              ],
              "middle": [
                "media"
              ],
              "right": [
                "volume",
                "network",
                "bluetooth",
                "battery",
                "systray",
                "clock",
                "notifications"
              ]
            },
            "1": {
              "left": [
                "dashboard",
                "workspaces",
                "windowtitle"
              ],
              "middle": [
                "media"
              ],
              "right": [
                "volume",
                "clock",
                "notifications"
              ]
            },
            "2": {
              "left": [
                "windowtitle"
              ],
              "middle": [],
              "right": []
            }
          },
          "bar.workspaces.workspaces": 10,
          "theme.bar.margin_sides": "0.8em",
          "bar.launcher.autoDetectIcon": true,
          "theme.bar.buttons.y_margins": "0.4em",
          "theme.bar.outer_spacing": "0.0em",
          "menus.dashboard.shortcuts.left.shortcut1.icon": "󰈹",
          "menus.dashboard.shortcuts.left.shortcut1.command": "firefox",
          "menus.dashboard.shortcuts.left.shortcut1.tooltip": "Firefox",
          "menus.dashboard.shortcuts.left.shortcut2.command": "alacritty -e btop",
          "menus.dashboard.shortcuts.left.shortcut2.tooltip": "Resource monitor",
          "menus.dashboard.shortcuts.left.shortcut2.icon": "",
          "menus.dashboard.shortcuts.left.shortcut3.icon": "󰟵",
          "menus.dashboard.shortcuts.left.shortcut3.command": "1password",
          "menus.dashboard.shortcuts.left.shortcut3.tooltip": "1Password",
          "menus.dashboard.directories.right.directory3.label": "󱂵  Home",
          "menus.dashboard.directories.right.directory2.label": "󰉏  Pictures",
          "menus.dashboard.directories.right.directory1.label": "󱧶  Documents",
          "menus.dashboard.directories.left.directory3.label": "󰚝  Projects",
          "menus.dashboard.directories.left.directory2.label": "󰉏  Videos",
          "menus.dashboard.directories.left.directory1.label": "󰉍  Downloads",
          "theme.bar.buttons.modules.power.enableBorder": false,
          "theme.osd.enable": true,
          "menus.clock.weather.enabled": false,
          "menus.clock.weather.unit": "metric",
          "menus.clock.weather.location": "London",
          "menus.clock.time.hideSeconds": true,
          "menus.clock.time.military": true,
          "theme.bar.menus.menu.dashboard.scaling": 90,
          "theme.bar.menus.menu.notifications.scaling": 90,
          "menus.dashboard.powermenu.avatar.image": "${userSettings.targetDirectory}/profile.png",
          "theme.bar.menus.menu.dashboard.profile.size": "9.5em",
          "theme.bar.menus.menu.dashboard.profile.radius": "0.8em",
          "theme.bar.transparent": true,
          "theme.bar.buttons.workspaces.enableBorder": false,
          "theme.bar.dropdownGap": "3.5em",
          "theme.bar.buttons.padding_x": "0.7rem",
          "theme.bar.buttons.radius": "0.4em",
          "theme.bar.margin_top": "0.3em",
          "tear": true,
          "menus.power.lowBatteryNotification": true,
          "menus.power.lowBatteryThreshold": 40,
          "theme.font.name": "JetBrainsMonoNL Nerd Font Propo Medium"
        }
      '';
    };
  };
}