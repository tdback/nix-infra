{
  imports = [
    ./hardware.nix
    ./network.nix
  ];

  my.modules.zfs = {
    enable = true;
    hostId = "e10f3c85";
    extraPools = [
      "tank-0"
      "tank-1"
    ];
  };

  my.services.tailscale.enable = true;
}
