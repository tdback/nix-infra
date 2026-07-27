{
  config,
  lib,
  ...
}:
let
  cfg = config.my.modules.nvidia;
in
{
  options.my.modules.nvidia.enable = lib.mkEnableOption "nvidia";

  config = lib.mkIf cfg.enable {
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      open = false;
      branch = "stable";
      nvidiaPersistenced = true;
      nvidiaSettings = !config.hardware.nvidia.nvidiaPersistenced;
    };
  };
}
