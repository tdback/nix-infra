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
  };

  config = lib.mkIf cfg.enable {
    networking.hostId = cfg.hostId;

    boot.supportedFilesystems.zfs = lib.mkForce true;
    boot.zfs.forceImportRoot = false;
  };
}
