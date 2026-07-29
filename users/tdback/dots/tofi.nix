{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.tofi = {
    enable = true;
    settings = {
      require-match = true;
      history = true;
      prompt-text = "run: ";
      prompt-padding = 0;
      font = "Terminess Nerd Font Mono";
      font-size = 15;
      text-color = "#FFFFFF";
      text-cursor = true;
      background-color = "#000A";
      scale = true;
      horizontal = false;
      anchor = "center";
      height = "100%";
      width = "100%";
      padding-top = "40%";
      padding-left = "40%";
      border-width = 0;
    };
  };

  # Delete cache on rebuilds.
  home.activation.regenerateTofiCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    TOFI_CACHE=${config.xdg.cacheHome}/tofi-drun
    [ -f "$TOFI_CACHE" ] && ${lib.getExe' pkgs.coreutils "rm"} "$TOFI_CACHE"
  '';
}
