{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.ai;
in {
  options.ai = {
    enable = lib.mkEnableOption "Enable agentic coding CLI tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      github-copilot-cli # Will also install Node.js
      claude-code
      pi-coding-agent
    ];

    environment.sessionVariables = {
      PI_SKIP_VERSION_CHECK = "1";
    };
  };
}
