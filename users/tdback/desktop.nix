{
  pkgs,
  ...
}:
{
  imports = [
    ./dots/firefox.nix
    ./dots/foot.nix
    ./dots/sway.nix
    ./dots/tofi.nix
  ];

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
}
