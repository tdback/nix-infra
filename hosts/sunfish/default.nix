{
  imports = [
    ./hardware.nix
    ./network.nix
  ];

  my.modules.zfs = {
    enable = true;
    hostId = "e10f3c85";
  };

  my.services.tailscale.enable = true;
}
