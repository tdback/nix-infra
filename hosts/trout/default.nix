{
  imports = [
    ./hardware.nix
    ./network.nix
  ];

  my.modules = {
    networkManager.enable = true;
    zfs = {
      enable = true;
      hostId = "44a4a60c";
    };
  };
}
