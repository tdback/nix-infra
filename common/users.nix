{
  config,
  pkgs,
  ...
}:
{
  users.mutableUsers = false;

  users.users.tdback = {
    uid = 1000;
    isNormalUser = true;
    home = "/home/tdback";
    group = "tdback";
    extraGroups = [ "wheel" ];
    shell = pkgs.bash;
    ignoreShellProgramCheck = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdwaIxcE1GIOUcmhU3JvnkctElHET+vZYUFhlAGOGOS tdback@trout"
    ];
  };
  users.groups.tdback.gid = config.users.users.tdback.uid;

  users.users.root = {
    hashedPasswordFile = null;
    openssh.authorizedKeys.keys =
      config.users.users.tdback.openssh.authorizedKeys.keys;
  };
}
