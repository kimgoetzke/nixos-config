{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    yazi.enable = lib.mkEnableOption "Enable yazi, the terminal-based file manager";
  };

  config = lib.mkIf config.yazi.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;

      # For more options, see: https://yazi-rs.github.io/docs/configuration/overview
      settings = {
        log = {enabled = false;};
        manager = {
          show_hidden = true;
          show_symlink = true;
          sort_by = "modified";
          sort_dir_first = true;
          sort_reverse = true;
        };
      };
    };
  };
}
