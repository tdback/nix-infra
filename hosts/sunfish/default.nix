{
  imports = [
    ./hardware.nix
    ./network.nix
  ];

  my.modules = {
    nvidia.enable = true;
    zfs = {
      enable = true;
      hostId = "e10f3c85";
      extraPools = [
        "tank-0"
        "tank-1"
      ];
    };
  };

  my.services = {
    jellyfin.enable = true;
    tailscale.enable = true;
  };
}
