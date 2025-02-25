{
  pkgs,
  config,
  lib,
  userSettings,
  ...
}: let
  cfg = config.posting;
in {
  options.posting = {
    enable = lib.mkEnableOption "Enable Posting, the TUI HTTP client";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      posting
    ];

    home-manager.users.${userSettings.user}.home.file.".config/posting/config.yaml" = {
      text = ''
        theme: nord
      '';
    };
  };
}
