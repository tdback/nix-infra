{
  imports = [
    ./hardware.nix
    ./network.nix
  ];

  my.modules = {
    laptop.enable = true;
    networkManager.enable = true;
    zfs = {
      enable = true;
      hostId = "44a4a60c";
    };
  };

  my.services.tailscale.enable = true;
}
