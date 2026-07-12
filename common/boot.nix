{
  config,
  lib,
  ...
}:
{
  boot.tmp.useTmpfs = lib.mkDefault true;
  boot.tmp.cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);
}
