{
  config,
  lib,
  ...
}: let
  cfg = config.wezterm;
in {
  options.wezterm = {
    enable = lib.mkEnableOption "Enable Wezterm";
  };

  config = lib.mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      extraConfig = builtins.readFile ./../../assets/configs/wezterm/wezterm.lua;
    };
  };
}
