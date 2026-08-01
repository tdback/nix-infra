{
  imports = [
    ./hardware.nix
    ./network.nix
  ];

  my.services = {
    matrix.enable = true;
    qemuGuest.enable = true;
    tailscale.enable = true;
  };
}
