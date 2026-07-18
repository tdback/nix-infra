{
  config,
  lib,
  ...
}:
let
  cfg = config.my.modules.laptop;
in
{
  options.my.modules.laptop = {
    enable = lib.mkEnableOption "laptop";
    chargeThreshold = lib.mkOption {
      default = { };
      type = lib.types.submodule {
        options = {
          start = lib.mkOption {
            type = lib.types.int;
            default = 85;
          };
          stop = lib.mkOption {
            type = lib.types.int;
            default = 90;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # gesture support
    services.libinput.enable = true;

    # temperature management for Intel CPUs
    services.thermald.enable = true;

    # battery health
    services.tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESHOLD_BAT0 = cfg.chargeThreshold.start;
        STOP_CHARGE_THRESHOLD_BAT0 = cfg.chargeThreshold.stop;
      };
    };
  };
}
