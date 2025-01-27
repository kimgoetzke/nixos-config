{
  config,
  lib,
  ...
}: let
  cfg = config.nvim;
in {
  options.nvim = {
    enable = lib.mkEnableOption "Enable Neovim";
  };

  config = lib.mkIf cfg.enable {
    #programs.neovim = {
    #  enable = true;
    #  viAlias = true;
    #  vimAlias = true;
    #  vimdiffAlias = true;
    #  extraPackages = [
    #    pkgs.shfmt
    #  ];
    #};
    programs.nixvim = {
      enable = true;
      colorschemes.nord.enable = true;
      viAlias = true;
      vimAlias = true;

      #      lsp.
      #enableNixIntegration = true;
    };
  };
}
