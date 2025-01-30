{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.firefox;
in {
  imports = [inputs.textfox.homeManagerModules.default];

  options.firefox = {
    enable = lib.mkEnableOption "Enable Mozilla Firefox";
    withProfile = lib.mkEnableOption "Enable configured Firefox profile";
    withTextfox = lib.mkEnableOption "Enable the amazing Textfox theme";
  };

  config = lib.mkIf cfg.enable {
    home.file.".mozilla/firefox/default/chrome/firefox-nord-theme".source = inputs.firefox-nord-theme;
    programs.firefox = {
      enable = true;
      policies = {
        AutoFillCreditCardEnabled = false;
        AppAutoUpdate = false;
        BackgroundAppUpdate = false;
        DisableAppUpdate = true;
        DisableAccounts = false;
        DisableFirefoxAccounts = false;
        DisablePocket = true;
        DisableFormHistory = true;
        DisableMasterPasswordCreation = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
        DefaultDownloadDirectory = "\${home}/Downloads";
      };
      profiles.default = lib.mkIf cfg.withProfile {
        id = 0;
        isDefault = true;
        name = "default";
        bookmarks = [];
        userChrome = lib.mkIf (cfg.withTextfox == false) ''
          @import "firefox-nord-theme/userChrome.css";
        '';
        userContent = lib.mkIf (cfg.withTextfox == false) ''
          @import "firefox-nord-theme/theme/nordic-theme.css";
        '';
        settings = {
          # Disable about:config warning
          "browser.aboutConfig.showWarning" = false;

          # Homepage settings
          # 0 = blank, 1 = home, 2 = last visited page, 3 = resume previous session
          "browser.startup.page" = 3;
          "browser.startup.homepage" = "about:home";

          # Language settings
          "intl.locale.requested" = "en-GB";
          "browser.shell.checkDefaultBrowser" = false;
          "browser.shell.defaultBrowserCheckCount" = 1;
          "browser.search.region" = "GB";
          "browser.search.isUS" = false;
          "distribution.searchplugins.defaultLocale" = "en-GB";
          "general.useragent.locale" = "en-GB";

          # Miscellanous settings
          "browser.download.panel.shown" = true;
          "browser.download.useDownloadDir" = false;

          # Extensions
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # Prevent WebRTC leaking IP address
          "media.peerconnection.ice.default_address_only" = true;

          # Activity Stream
          "browser.newtab.preload" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.default.sites" = "";
        };
        search = {
          force = true;
          engines = {
            "NixOS Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["np"];
            };
            "NixOS Options" = {
              urls = [{template = "https://search.nixos.org/options?from=0&size=50&sort=relevance&query={searchTerms}";}];
              definedAliases = ["no"];
            };
            "NixOS Wiki" = {
              urls = [{template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";}];
              iconUpdateURL = "https://wiki.nixos.org/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["nw"];
            };
            "YouTube" = {
              urls = [{template = "https://www.youtube.com/results?search_query={searchTerms}";}];
              definedAliases = ["y"];
            };
            "Amazon" = {
              urls = [{template = "https://www.amazon.co.uk/s?k={searchTerms}";}];
              definedAliases = ["a"];
            };
            "JWT.io" = {
              urls = [{template = "https://jwt.io/?value={searchTerms}";}];
              definedAliases = ["jwt"];
            };
            "dict.cc" = {
              urls = [{template = "https://www.dict.cc/?s={searchTerms}";}];
              definedAliases = ["d"];
            };
            "home-manager options" = {
              urls = [{template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";}];
              definedAliases = ["hmo"];
            };
            "Bing".metaData.hidden = true;
            "eBay".metaData.hidden = true;
            "Wikipedia (en)".metaData.hidden = true;
            "Google".metaData.alias = "@g";
            "DuckDuckGo".metaData.alias = "ddg";
          };
        };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          onepassword-password-manager
          tridactyl
          firefox-color
        ];
      };
    };

    textfox = lib.mkIf cfg.withTextfox {
      enable = true;
      profile = "default";
      config = {
        displayNavButtons = true;
        displayHorizontalTabs = true;
        background = {
          color = "#2e3440"; # Or 1f242d; note that this doesn't change the full background, you appear to need firefox-color for that
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

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = ["firefox.desktop"];
      "text/xml" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
    };
  };
}
