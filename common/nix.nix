{
  lib,
  ...
}:
{
  system.stateVersion = "24.11";

  nix.settings.experimental-features = lib.mkDefault [
    "flakes"
    "nix-command"
  ];
}
