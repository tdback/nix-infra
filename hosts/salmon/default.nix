{
  imports = [
    ./hardware.nix
    ./network.nix
  ];

  my.services.tailscale.enable = true;
}
