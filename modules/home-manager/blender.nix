{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.blender;
  blenderVersion = lib.versions.majorMinor pkgs.blender.version;
  blenderMcp = pkgs.fetchgit {
    url = "https://projects.blender.org/lab/blender_mcp.git";
    rev = "2cea8d566dde07fbac28a61d698909d69724e853"; # v1.0.3
    hash = "sha256-pYeByO4Oi5eyynsJhGVd1vBWXHvhGn+Y5LGit6Kazlw=";
  };
in {
  options.blender = {
    enable = lib.mkEnableOption "Blender";
    withMcp = lib.mkEnableOption "the Blender Lab MCP extension";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.blender];

    xdg.configFile = lib.mkIf cfg.withMcp {
      "blender/${blenderVersion}/extensions/user_default/mcp".source = "${blenderMcp}/addon/blender_mcp_addon";
    };
  };
}
