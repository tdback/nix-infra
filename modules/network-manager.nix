{
  config,
  lib,
  ...
}:
let
  cfg = config.my.modules.networkManager;
in
{
  options.my.modules.networkManager.enable = lib.mkEnableOption "NetworkManager";

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;
    users.users.tdback.extraGroups = [ "networkmanager" ];
  };
}
