{
  networking = {
    hostName = "salmon";
    defaultGateway6.address = "fe80::1";
    interfaces."ens3" = {
      useDHCP = true;
      ipv6.addresses = [
        {
          address = "2a03:4000:42:f0b::1";
          prefixLength = 64;
        }
      ];
    };
  };
}
