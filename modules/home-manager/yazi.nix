{
  config,
  inputs,
  lib,
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
        max-preview = "${inputs.yazi-plugins}/max-preview.yazi";
        full-border = "${inputs.yazi-plugins}/full-border.yazi";
        smart-enter = "${inputs.yazi-plugins}/smart-enter.yazi";
        wl-clipboard = "${inputs.yazi-plugins-wl-clipboard}";
      };
      initLua = ''
        require("full-border"):setup()
      '';
      keymap = {
        manager.prepend_keymap = [
          {
            on = "T";
            run = "plugin max-preview";
            desc = "Maximize or restore the preview pane";
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
            on = "<C-Up>";
            run = "seek -5";
            desc = "Seek up 5 units in the preview";
          }
          {
            on = "<C-Down>";
            run = "seek 5";
            desc = "Seek down 5 units in the preview";
          }
        ];
      };
    };

    home.sessionVariables = {
      YAZI_CONFIG_HOME = "~/.config/yazi";
    };

    home.file.".config/yazi/yazi.toml" = {
      source = ./../../assets/configs/yazi/yazi.toml;
    };
  };
}
