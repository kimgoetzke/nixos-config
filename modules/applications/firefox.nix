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
          "browser.search.region" = "GB";
          "browser.search.isUS" = false;
          "browser.startup.homepage" = "https://kimgoetzke.github.io/";
          "distribution.searchplugins.defaultLocale" = "en-GB";
          "general.useragent.locale" = "en-GB";
        };
        search.engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "np" ];
          };
          "NixOS Wiki" = {
            urls = [{ template = "https://wiki.nixos.org/index.php?search={searchTerms}"; }];
            iconUpdateURL = "https://wiki.nixos.org/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nw" ];
          };
          "YouTube" = {
            urls = [{ template = "https://www.youtube.com/results?search_query={searchTerms}"; }];
            definedAliases = [ "y" ];
          };
          "Amazon" = {
            urls = [{ template = "https://www.amazon.co.uk/s?k={searchTerms}"; }];
            definedAliases = [ "a" ];
          };
          "JWT.io" = {
            urls = [{ template = "https://jwt.io/?value={searchTerms}"; }];
            definedAliases = [ "jwt" ];
          };
          "dict.cc" = {
            urls = [{ template = "https://www.dict.cc/?s={searchTerms}"; }];
            definedAliases = [ "d" ];
          };
          "Bing".metaData.hidden = true;
          "Google".metaData.alias = "@g";
          "DuckDuckGo".metaData.alias = "ddg";
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