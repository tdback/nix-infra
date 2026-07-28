{
  inputs,
  config,
  lib,
  pkgs,
  desktop,
  ...
}:
{
  config = lib.mkMerge [
    {
      users.mutableUsers = false;

      users.users.tdback = {
        uid = 1000;
        isNormalUser = true;
        hashedPasswordFile = lib.mkDefault null;
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
        openssh.authorizedKeys.keys = config.users.users.tdback.openssh.authorizedKeys.keys;
      };
    }

    (lib.mkIf desktop {
      age.identityPaths = [ "/home/tdback/.ssh/id_ed25519" ];
      age.secrets.hashedPassword.file = "${inputs.self}/secrets/hashed-password.age";

      # Set the password for interactive logins.
      users.users.tdback.hashedPasswordFile = lib.mkForce config.age.secrets.hashedPassword.path;

      # Mount the "/home" dataset on ZFS systems at boot, or else agenix won't
      # be able to find the key used to decrypt the password file.
      fileSystems."/home".neededForBoot = config.boot.supportedFilesystems.zfs;
    })
  ];
}
