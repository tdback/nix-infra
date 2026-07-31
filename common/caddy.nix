{
  config,
  lib,
  desktop,
  ...
}:
let
  cfg = config.services.caddy;
in
{
  config = lib.mkIf (!desktop) {
    services.caddy = {
      enable = cfg.virtualHosts != { };
      openFirewall = cfg.enable;
      email = "acme@tdback.net";
    };
  };
}
