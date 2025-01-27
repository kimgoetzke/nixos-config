{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.gaming;
in {
  options.gaming = {
    enable = lib.mkEnableOption "Enable gaming mode incl. Steam";
  };

  config = lib.mkIf cfg.enable {
    # NOTES:
    # - Run the following command: protonup
    # - Check compatibility of games here: https://www.protondb.com
    # - To use gamemode, run games with launch option: gamemoderun %command% (set in Steam by right clicking game -> Properties -> Launch Options...)
    # - To use mangohud, run games with launch option: mangohud %command% (set in Steam by right clicking game -> Properties -> Launch Options...)

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      gamescopeSession.enable = true;
    };

    environment.systemPackages = with pkgs; [
      mangohud
      protonup
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };

    programs.gamemode.enable = true;
  };
}
