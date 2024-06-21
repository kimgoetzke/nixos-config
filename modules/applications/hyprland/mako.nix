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
      anchor = "top-center";
      defaultTimeout = 5000;
      borderSize = 3;
      borderRadius = 10;
      padding = "20";
      margin = "5";
      sort = "-time";
      format = "<b>%s</b>\\n<span color=\"${config.lib.stylix.colors.withHashtag.base03}\">(%a)</span>\\n%b";
      extraConfig = ''
        background-color=${config.lib.stylix.colors.withHashtag.base00}D9
        outer-margin=30
        [urgency=low]
        border-color=${config.lib.stylix.colors.withHashtag.base0D}
        [urgency=normal]
        border-color=${config.lib.stylix.colors.withHashtag.base0C}
        [urgency=high]
        border-color=${config.lib.stylix.colors.withHashtag.base0B}
        default-timeout=20000
      '';
      # Note: You can create app specific rules like this:
      # [app-name=notify-send]
      # format=<b>%s</b>\n%b
    };
  };
}
