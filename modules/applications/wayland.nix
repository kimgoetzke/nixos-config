{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.wayland;
  #  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
  #    ${pkgs.waybar}/bin/waybar &
  #    ${pkgs.swww}/bin/swww init &
  #
  #    sleep 1
  #
  #    ${pkgs.swww}/bin/swww img ${./../../assets/images/wallpaper_abstract_nord4x.png} &
  #  '';
in {
  options.wayland = {
    enable = lib.mkEnableOption "Use Wayland";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.variables = ["--all"];
      settings = {
        "$mod" = "SUPER";
        bind =
          [
            "$mod, F, exec, firefox"
            ", Print, exec, grimblast copy area"
          ]
          ++ (
            # Binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
            builtins.concatLists (builtins.genList (
                x: let
                  ws = let
                    c = (x + 1) / 10;
                  in
                    builtins.toString (x + 1 - (c * 10));
                in [
                  "$mod, ${ws}, workspace, ${toString (x + 1)}"
                  "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                ]
              )
              10)
          );
      };
    };
  };
}
