{
  lib,
  desktop,
  ...
}:
{
  networking.domain = "tdback.net";

  # use nftables in place of iptables
  networking.nftables.enable = true;
  networking.firewall.allowPing = lib.mkDefault (!desktop);

  # upstream servers to be used by stub resolver
  networking.nameservers = [
    "9.9.9.9#dns.quad9.net"
    "149.112.112.112#dns.quad9.net"
  ];

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSOverTLS = "true";
      DNSSEC = "false";
    };
  };
}
