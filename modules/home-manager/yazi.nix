{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  options = {
    yazi.enable = lib.mkEnableOption "Enable Yazi, the terminal-based file manager";
  };

  config = lib.mkIf config.yazi.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";
      plugins = {
        piper = "${inputs.yazi-plugins}/piper.yazi";
        toggle-pane = "${inputs.yazi-plugins}/toggle-pane.yazi";
        full-border = "${inputs.yazi-plugins}/full-border.yazi";
        smart-enter = "${inputs.yazi-plugins}/smart-enter.yazi";
        wl-clipboard = "${inputs.yazi-plugins-wl-clipboard}";
      };
      initLua = ''
        require("full-border"):setup()
      '';
      keymap = {
        mgr.prepend_keymap = [
          {
            on = "T";
            run = "plugin toggle-pane max-preview";
            desc = "Maximise or restore the preview pane";
          }
          {
            on = "<C-t>";
            run = "plugin toggle-pane min-preview";
            desc = "Show or hide the preview pane";
          }
          {
            on = "l";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
          {
            on = "<C-y>";
            run = "plugin wl-clipboard";
            desc = "Copy to wl-clipboard";
          }
          {
            on = "<S-Up>";
            run = "seek -5";
            desc = "Seek up 5 units in the preview";
          }
          {
            on = "<S-Down>";
            run = "seek 5";
            desc = "Seek down 5 units in the preview";
          }
        ];
      };
    };

    home.sessionVariables = {
      YAZI_CONFIG_HOME = "~/.config/yazi";
    };

    # Install glow for working with markdown
    home.packages = [ pkgs.glow ];

    home.file.".config/yazi/yazi.toml" = {
      source = ./../../assets/configs/yazi/yazi.toml;
    };
  };
}
