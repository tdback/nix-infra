{
  config,
  ...
}:
{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";

    # https://mozilla.github.io/policy-templates/
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableAccounts = true;
      DisableFirefoxAccounts = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DefaultDownloadDirectory = config.xdg.userDirs.download;
      DisplayMenuBar = "default-off";
      DisplayBookmarkToolbar = "newtab";
      SearchBar = "unified";
      Preferences =
        let
          lock-true = {
            Value = true;
            Status = "locked";
          };
          lock-false = {
            Value = false;
            Status = "locked";
          };
        in
        {
          "extensions.pocket.enabled" = lock-false;
          "extensions.screenshots.disabled" = lock-true;
          "browser.topsites.contile.enabled" = lock-false;
          "browser.formfill.enable" = lock-false;
          "browser.search.suggest.enabled" = lock-false;
          "browser.search.suggest.enabled.private" = lock-false;
          "browser.urlbar.suggest.searches" = lock-false;
          "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
          "browser.newtabpage.activity-stream.feeds.weatherfeed" = lock-false;
          "browser.newtabpage.activity-stream.showWeather" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        };
      ExtensionSettings = {
        "*".installation_mode = "blocked";
        # Ublock Origin.
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        # Bitwarden client.
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        # Dark Reader.
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
      };
    };

    # Search overrides for the default profile.
    profiles.${config.home.username}.search = {
      force = true;
      default = "ddg";
      engines = {
        "wikipedia".metaData.alias = "@w";
        # Disable other search engines.
        "amazondotcom-us".metaData.hidden = true;
        "bing".metaData.hidden = true;
        "ebay".metaData.hidden = true;
        "google".metaData.hidden = true;
      };
    };
  };
}
