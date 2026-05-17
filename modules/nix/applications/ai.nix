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
      chromium # Optional improvement for https://github.com/kimgoetzke/coding-agent-configs/tree/main/.pi/agent/extensions/web-tools
    ];

    environment.sessionVariables = {
      PI_SKIP_VERSION_CHECK = "1";
      PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH = lib.getExe pkgs.chromium;
    };
  };
}
