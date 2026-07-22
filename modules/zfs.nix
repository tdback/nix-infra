{
  config,
  lib,
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
  };

  config = lib.mkIf cfg.enable {
    networking.hostId = cfg.hostId;

    boot.supportedFilesystems.zfs = lib.mkForce true;
    boot.zfs.forceImportRoot = false;

    services.zfs = {
      autoScrub = {
        enable = true;
        interval = cfg.scrubInterval;
      };
    };
  };
}
