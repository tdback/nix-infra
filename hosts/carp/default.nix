{
  imports = [
    ./hardware.nix
    ./network.nix
  ];

  my.modules = {
    networkManager.enable = true;
    zfs = {
      enable = true;
      hostId = "644db639";
    };
  };

  my.services.tailscale.enable = true;
}
