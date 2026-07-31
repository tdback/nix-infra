{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.qemuGuest;
in
{
  options.my.services.qemuGuest.enable = lib.mkEnableOption "qemu guest agent";

  config = lib.mkIf cfg.enable {
    services.qemuGuest.enable = true;
  };
}
