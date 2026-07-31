{
  imports = [
    ./hardware.nix
    ./network.nix
  ];

  my.services = {
    qemuGuest.enable = true;
    tailscale.enable = true;
  };
}
