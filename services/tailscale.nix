{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.tailscale;
in
{
  options.my.services.tailscale.enable = lib.mkEnableOption "tailscale";

  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;

    # Permit all tailscale network traffic.
    networking.firewall = {
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };

    # Avoid "iptables-compat" translation layer issues when using nftables.
    systemd.services.tailscaled.serviceConfig.Environment =
      lib.optional config.networking.nftables.enable "TS_DEBUG_FIREWALL_MODE=nftables";

    # Avoid longer boot times caused by network initialization at boot.
    boot.initrd.systemd.network.wait-online.enable = false;
    systemd.network.wait-online.enable = false;
  };
}
