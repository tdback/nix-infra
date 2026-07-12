{
  inputs,
  lib,
  ...
}:
{
  system.stateVersion = "24.11";

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = lib.mkDefault [
      "flakes"
      "nix-command"
    ];
  };

  nixpkgs.overlays = [
    (final: _: {
      unstable = import inputs.nixpkgs-unstable {
        system = final.stdenv.hostPlatform.system;
      };
    })
  ];
}
