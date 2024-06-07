{
  config,
  lib,
  ...
}: let
  cfg = config.bash;
  
  # My shell aliases
  myAliases = {
    idea = "~/.local/share/JetBrains/Toolbox/apps/intellij-idea-ultimate/bin/idea.sh";
    webstorm = "/path/to/idea.sh";
    rider = "/path/to/idea.sh";
    proper = "cd ~/projects && ls -1";
    kim = "/path/to/idea.sh";
    nht = "nh os test ~/projects/nixos-config -H default";
    nhs = "nh os switch ~/projects/nixos-config -H default";
  };
in {
  options.bash = {
    enable = lib.mkEnableOption "Enable Bash and set aliases";
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = myAliases;
    };
  };
}
