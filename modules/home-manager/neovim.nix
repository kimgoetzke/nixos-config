{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.nvim;
  treesitterWithGrammars = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.comment
    p.css
    p.dockerfile
    p.gitattributes
    p.gitignore
    p.go
    p.gomod
    p.gowork
    p.hcl
    p.html
    p.java
    p.javascript
    p.jq
    p.json5
    p.json
    p.lua
    p.make
    p.markdown
    p.nix
    p.rust
    p.toml
    p.typescript
    p.yaml
  ]);

  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = treesitterWithGrammars.dependencies;
  };
in {
  options.nvim = {
    enable = lib.mkEnableOption "Enables Neovim";
  };

  config = lib.mkIf cfg.enable {
    #    nix.nixPath = [
    #      "nixpkgs=${inputs.nixpkgs}"
    #    ];
    home.packages = with pkgs; [
      ripgrep
      fd
      lua-language-server
      rust-analyzer-unwrapped
      gh
      go
      gopls
      nix-doc
      nil
      jdt-language-server
      alejandra
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      plugins = [
        treesitterWithGrammars
      ];
      extraPackages = [
        pkgs.nil
      ];
    };
    stylix.targets.neovim.enable = false;
    home.file."./.config/nvim" = {
      source = ./../../assets/configs/neovim;
      recursive = true;
    };

    home.file."./.config/nvim/lua/custom/init.lua".text = ''
      require("custom.set")
      require("custom.remap")
      vim.opt.runtimepath:append("${treesitter-parsers}")
    '';

    # Treesitter is configured as a locally developed module in lazy.nvim
    # we hardcode a symlink here so that we can refer to it in our lazy config
    home.file."./.local/share/nvim/nix/nvim-treesitter/" = {
      recursive = true;
      source = treesitterWithGrammars;
    };
  };
}
