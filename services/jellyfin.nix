{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.jellyfin;
  hasGPU = lib.elem "nvidia" config.services.xserver.videoDrivers;
in
{
  options.my.services.jellyfin = {
    enable = lib.mkEnableOption "jellyfin";
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/jellyfin";
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
      dataDir = cfg.dataDir;
      hardwareAcceleration = {
        enable = hasGPU;
        device = "/dev/dri/card0";
        type = "nvenc";
      };
    };
  };
}
