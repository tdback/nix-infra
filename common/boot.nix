{
  config,
  lib,
  ...
}:
let
  maxGenerations = 8;
in
{
  boot.tmp.useTmpfs = lib.mkDefault true;
  boot.tmp.cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);

  # limit generations to avoid filling up "/boot"
  boot.loader.grub.configurationLimit = lib.mkDefault maxGenerations;
  boot.loader.systemd-boot.configurationLimit = lib.mkDefault maxGenerations;
}
