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
}
