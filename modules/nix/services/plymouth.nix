{
  config,
  lib,
  ...
}: let
  cfg = config.plymouth;
in {
  options.plymouth = {
    enable = lib.mkEnableOption "Enable Plymouth, an application that runs early in the boot process, providing a graphical boot animation";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      plymouth = {
        enable = true;
        # theme = lib.mkForce "glitch";
        # themePackages = with pkgs; [
        #   # https://github.com/adi1090x/plymouth-themes
        #   (adi1090x-plymouth-themes.override {
        #     selected_themes = [ "glitch" ];
        #   })
        # ];
      };

      # Enable "Silent boot"
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "udev.log_level=3"
        "systemd.show_status=auto"
      ];
    };

    # With Stylix, we'll get theming and a rotating NixOS logo by default; the below disables the animation
    # - see https://nix-community.github.io/stylix/options/modules/plymouth.html
    stylix.targets.plymouth.logoAnimated = false;
  };
}
