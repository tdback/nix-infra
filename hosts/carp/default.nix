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
      extraPools = [ "tank-0" ];
    };
  };

  my.services = {
    fail2ban.enable = true;
    tailscale.enable = true;
  };
}
