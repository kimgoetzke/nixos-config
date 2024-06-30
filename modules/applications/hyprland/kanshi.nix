{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    kanshi.enable = lib.mkEnableOption "Enable kanshi to manage monitor profiles";
  };

  config = lib.mkIf config.kanshi.enable {
    home.packages = with pkgs; [
      kanshi
    ];

    # TODO: Try again to make kanshi work
    # I stopped this because it appeared to ignore most of the settings e.g. scale, position, and status.
    # At least some of those are known issues with the current Hyprland version, so it may be worth trying
    # again later.
    # To use it, go to 'hyprland.nix', set 'kanshi.enable = true', and add the below to exec-once:
    # "${pkgs.kanshi}/bin/kanshi"
    services.kanshi = {
      enable = true;
      package = pkgs.kanshi;
      systemdTarget = "hyprland-session.target";
      settings = [
        {
          profile.name = "undocked";
          profile.outputs = [
            {
              criteria = "eDP-1";
              scale = 1.00; # Nix will fail to compile with '1'
              mode = "2560x1440@60.00Hz";
            }
          ];
        }
        {
          profile.name = "primary_office";
          profile.outputs = [
            {
              criteria = "DP-2"; # Add name of monitor here
              position = "0,0";
              mode = "2560x1440@60Hz";
              transform = "flipped-90";
            }
            {
              criteria = "GIGA-BYTE TECHNOLOGY CO. LTD. G32QC 20170B001579";
              position = "1440,500";
              mode = "2560x1440@60Hz";
            }
            {
              criteria = "eDP-1";
              status = "disable";
            }
          ];
        }
        {
          profile.name = "secondary_office";
          profile.outputs = [
            {
              criteria = "HDMI-A-1"; # Try use monitor name here as it'll otherwise interfere with future configurations
              position = "0,0";
              scale = 1.00;
              mode = "2560x1440@120.00Hz";
            }
            {
              criteria = "eDP-1";
              position = "0,1440";
              scale = 1.00;
              mode = "2560x1440@60.00Hz";
              status = "disable";
            }
          ];
        }
      ];
    };
  };
}
