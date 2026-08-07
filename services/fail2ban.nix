{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.fail2ban;
in
{
  options.my.services.fail2ban.enable = lib.mkEnableOption "fail2ban";

  config = lib.mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      ignoreIP = lib.optional config.services.tailscale.enable "100.64.0.0/10";
    };
  };
}
