{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.firefox-textfox;
in {
  imports = [inputs.textfox.homeManagerModules.default];

  options = {
    firefox-textfox.enable = lib.mkEnableOption "Enable Textfox, a Firefox theme";
  };

  # Enabling Textfox will override any Firefox theme configuration declared in firefox.nix
  config = lib.mkIf cfg.enable {
    textfox = {
      enable = true;
      profile = "default";
      config = {
        displayNavButtons = true;
        displayHorizontalTabs = true;
        background = {
          # TODO: Make the background colour work for the window background, not just the menu background
          color = "#1f242d";
        };
        border = {
          color = "#4c566a";
          width = "3px";
          transition = "1.0s ease";
          radius = "5px";
        };
        newtabLogo = "   __            __  ____          \A   / /____  _  __/ /_/ __/___  _  __\A  / __/ _ \\| |/_/ __/ /_/ __ \\| |/_/\A / /_/  __/>  </ /_/ __/ /_/ />  <  \A \\__/\\___/_/|_|\\__/_/  \\____/_/|_|  ";
        font = {
          family = "JetBrainsMono Nerd Font";
          size = "15px";
          accent = "#81A1C1";
        };
      };
    };
  };
}
