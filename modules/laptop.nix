{
  config,
  lib,
  ...
}:
let
  cfg = config.my.modules.laptop;
in
{
  options.my.modules.laptop.enable = lib.mkEnableOption "laptop";

  config = lib.mkIf cfg.enable {
    # gesture support
    services.libinput.enable = true;

    # temperature management for Intel CPUs
    services.thermald.enable = true;

    # battery health
    services.tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESHOLD_BAT0 = 85;
        STOP_CHARGE_THRESHOLD_BAT0 = 90;
      };
    };
  };
}
