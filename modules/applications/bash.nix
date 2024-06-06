{
  config,
  lib,
  ...
}: let
  cfg = config.bash;
  
  # My shell aliases
  myAliases = {
    idea = "/path/to/idea.sh";
    webstorm = "/path/to/idea.sh";
    rider = "/path/to/idea.sh";
    proper = "/path/to/idea.sh";
    kim = "/path/to/idea.sh";
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
