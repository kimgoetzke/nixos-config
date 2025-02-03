{
  config,
  lib,
  ...
}: let
  cfg = config.nixvim;
in {
  imports = [
    ./bufferline.nix
    ./neo-tree.nix
    ./cmp.nix
    ./which-key.nix
  ];

  options.nixvim = {
    enable = lib.mkEnableOption "Enable Neovim via the Nixvim distribution";
  };

  config = lib.mkIf cfg.enable {
    stylix.targets.nixvim.enable = false;
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      colorschemes.nord = {
        enable = true;
        settings = {
          disable_background = false;
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
        clipboard = {
          providers = {
            wl-copy.enable = true; # Wayland
            xsel.enable = true; # For X11
          };
          register = "unnamedplus";
        };
      };

      globals.mapleader = " ";

      keymaps = [
        {
          mode = "n";
          key = "<C-h>";
          action = "<C-w><C-h>";
          options = {
            desc = "Move focus to the left window";
            remap = true;
          };
        }
        {
          mode = "n";
          key = "<C-l>";
          action = "<C-w><C-l>";
          options = {
            desc = "Move focus to the right window";
            remap = true;
          };
        }
        {
          mode = "n";
          key = "<C-j>";
          action = "<C-w><C-j>";
          options = {
            desc = "Move focus to the lower window";
            remap = true;
          };
        }
        {
          mode = "n";
          key = "<C-k>";
          action = "<C-w><C-k>";
          options = {
            desc = "Move focus to the upper window";
            remap = true;
          };
        }
      ];

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
