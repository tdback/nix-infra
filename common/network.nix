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

  boot.kernelModules = [
    # congestion control
    "tcp_bbr"
  ];

  boot.kernel.sysctl = {
    # bufferbloat mitigation and latency reduction
    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";

    # reuse existing TIME-WAIT connections
    "net.ipv4.tcp_tw_reuse" = 1;

    # RFC 7413 TFO extension
    "net.ipv4.tcp_fastopen" = 3;
  };
}
