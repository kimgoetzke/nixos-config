{
  config,
  lib,
  ...
}: let
  cfg = config.bash;
in {
  options.bash = {
    enable = lib.mkEnableOption "Enable Bash and set aliases";
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      historyControl = "erasedups";
      historyFile = "${config.home}/.bash_history";
      historyFileSize = 5000;
      historyIgnore = [
        "ls"
        "ll"
        "la"
        "l"
        "cd"
        "pwd"
        "exit"
        "clear"
        "c"
        "nht"
        "nhs"
        "proper"
        "idea"
      ];
    };
  };
}
