{pkgs, inputs, config, lib, ...}: 

let
  cfg = config.firefox;
in
{
  options.firefox = {
    enable = lib.mkEnableOption "Enable Mozilla Firefox";
    withProfile = lib.mkEnableOption "Enable configured Firefox profile";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.default = lib.mkIf cfg.withProfile {
        id = 0;
        isDefault = true;
        name = "default";
        settings = {
          "browser.download.panel.shown" = true;
          "browser.download.useDownloadDir" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.shell.defaultBrowserCheckCount" = 1;
          "browser.startup.homepage" = "https://kimgoetzke.github.io/";
        };
        # extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        #   onepassword-password-manager
        # ];
      };
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = ["firefox.desktop"];
      "text/xml" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
    };
  };
}