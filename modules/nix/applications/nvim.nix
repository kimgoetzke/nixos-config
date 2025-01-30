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
    stylix.targets.nixvim.enable = false;
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      colorschemes.nord = {
        enable = true;
        settings = {
          disable_background = true;
          borders = true;
        };
      };
      viAlias = true;
      vimAlias = true;
      opts = {
        number = true;
        relativenumber = true;
        shiftwidth = 2;
        tabstop = 2;
      };
      clipboard.providers.wl-copy.enable = true;

      plugins.lsp = {
        enable = true;
        servers = {
          rust_analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;
          };
          lua_ls.enable = true;
          ts_ls.enable = true;
          cssls.enable = true;
          tailwindcss.enable = true;
          html.enable = true;
          nil_ls.enable = true; # Nix
          dockerls.enable = true;
          bashls.enable = true;
          yamlls.enable = true;
          csharp_ls.enable = true;
          gopls.enable = true; # Golang
        };
      };

      plugins.cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            {name = "path";}
            {name = "nvim_lsp";}
            {name = "luasnip";}
            {
              name = "buffer";
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            }
            {name = "neorg";}
          ];
        };
      };

      plugins.markdown-preview = {
        enable = true;
        settings = {
          auto_close = 0;
          theme = "dark";
        };
      };

      plugins.image = {
        enable = true;
        integrations = {
          markdown = {
            enabled = true;
            downloadRemoteImages = true;
          };
        };
      };

      plugins.telescope = {
        enable = true;
      };

      plugins.treesitter.enable = true;
      plugins.luasnip.enable = true;
      plugins.web-devicons.enable = true;
      plugins.oil.enable = true;

      plugins.colorizer = {
        enable = true;
        settings.user_default_options.names = false;
        settings.filetypes = ["css" "scss"];
      };
    };

    # home.sessionVariables = {
    #   EDITOR = "nvim";
    # };
  };
}
