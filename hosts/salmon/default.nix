{
  imports = [
    ./hardware.nix
    ./network.nix
  ];

  my.services = {
    fail2ban.enable = true;
    matrix.enable = true;
    qemuGuest.enable = true;
    tailscale.enable = true;
  };
}
