{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    mako.enable = lib.mkEnableOption "Enable mako";
  };

  config = lib.mkIf config.mako.enable {
    services.mako = {
      enable = true;
      anchor = "bottom-right";
      defaultTimeout = 5000;
      borderSize = 3;
      borderRadius = 7;
    };
  };
}
