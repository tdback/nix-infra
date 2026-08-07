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
    sftp = {
      enable = true;
      users = [
        {
          name = "slipstream";
          keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFGHctQvsapm0qe8vJ7DZcj/sKWg8YovJjt98rRNYF4I ty@OmniMan-Csh"
          ];
        }
      ];
    };
    tailscale.enable = true;
  };
}
