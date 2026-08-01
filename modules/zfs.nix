{
  config,
  lib,
  desktop,
  ...
}:
let
  cfg = config.my.modules.zfs;
in
{
  options.my.modules.zfs = {
    enable = lib.mkEnableOption "zfs";
    hostId = lib.mkOption {
      type = lib.types.str;
    };
    scrubInterval = lib.mkOption {
      type = lib.types.str;
      default = "monthly";
    };
    extraPools = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    networking.hostId = cfg.hostId;

    boot.supportedFilesystems.zfs = lib.mkForce true;
    boot.zfs = {
      forceImportRoot = false;
      extraPools = cfg.extraPools;
    };

    services.zfs = lib.mkMerge [
      {
        autoScrub = {
          enable = true;
          interval = cfg.scrubInterval;
        };
      }

      (lib.mkIf (!desktop) {
        zed = {
          enableMail = false;
          settings = {
            ZED_DEBUG_LOG = "/tmp/zed.debug.log";
            ZED_EMAIL_ADDR = [ "root@${config.networking.fqdn}" ];
            ZED_EMAIL_PROG = "/run/current-system/sw/bin/pushover";
            ZED_EMAIL_OPTS = "-t '@SUBJECT@'";
            ZED_NOTIFY_INTERVAL_SECS = 3600;
            ZED_NOTIFY_VERBOSE = true;
          };
        };
      })
    ];
  };
}
