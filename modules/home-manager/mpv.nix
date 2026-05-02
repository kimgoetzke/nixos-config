{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.mpv;
in {
  options.mpv = {
    enable = lib.mkEnableOption "Enable mpv, a media player";
  };

  config = lib.mkIf cfg.enable {
    programs.mpv = {
      enable = true;
      package = pkgs.mpv.override {youtubeSupport = false;};
    };
  };
}
