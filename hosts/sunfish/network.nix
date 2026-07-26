{
  networking = {
    hostName = "sunfish";
    defaultGateway.address = "192.168.0.1";
    interfaces."enp42s0" = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.0.5";
          prefixLength = 24;
        }
      ];
    };
  };
}
