{
  lib,
  ...
}:
{
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = lib.mkDefault false;
}
