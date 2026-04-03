{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.nvim;
  jetbrainsIslandsDarkPalette = {
    base00 = "#191A1C";
    base01 = "#1F2024";
    base02 = "#2B2D30";
    base03 = "#393B40";
    base04 = "#7A7E85";
    base05 = "#BCBEC4";
    base06 = "#CED0D6";
    base07 = "#DFE1E5";
    base08 = "#F75464";
    base09 = "#CF8E6D";
    base0A = "#E0BB65";
    base0B = "#6AAB73";
    base0C = "#2AACB8";
    base0D = "#56A8F5";
    base0E = "#C77DBB";
    base0F = "#D5B778";
  };
  themePalette =
    if lib.attrByPath ["stylix" "enable"] false config
    then config.lib.stylix.colors.withHashtag
    else jetbrainsIslandsDarkPalette;
  treesitterWithGrammars = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.comment
    p.css
    p.c_sharp
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
    p.ron
    p.toml
    p.typescript
    p.wgsl_bevy
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

    home.file."./.config/nvim/lua/custom/theme.lua".text = ''
      return {
        base00 = "${themePalette.base00}",
        base01 = "${themePalette.base01}",
        base02 = "${themePalette.base02}",
        base03 = "${themePalette.base03}",
        base04 = "${themePalette.base04}",
        base05 = "${themePalette.base05}",
        base06 = "${themePalette.base06}",
        base07 = "${themePalette.base07}",
        base08 = "${themePalette.base08}",
        base09 = "${themePalette.base09}",
        base0A = "${themePalette.base0A}",
        base0B = "${themePalette.base0B}",
        base0C = "${themePalette.base0C}",
        base0D = "${themePalette.base0D}",
        base0E = "${themePalette.base0E}",
        base0F = "${themePalette.base0F}",
      }
    '';

    # Treesitter is configured as a locally developed module in lazy.nvim
    # we hardcode a symlink here so that we can refer to it in our lazy config
    home.file."./.local/share/nvim/nix/nvim-treesitter/" = {
      recursive = true;
      source = treesitterWithGrammars;
    };
  };
}
