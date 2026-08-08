{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.sftp;

  mkUsers =
    users:
    lib.genAttrs' users (
      user:
      lib.nameValuePair user.name {
        isNormalUser = true;
        home = "/var/empty";
        createHome = false;
        name = user.name;
        group = cfg.group;
        shell = "/run/current-system/sw/bin/false";
        openssh.authorizedKeys.keys = user.keys;
      }
    );
in
{
  options.my.services.sftp = {
    enable = lib.mkEnableOption "sftp";
    group = lib.mkOption {
      type = lib.types.str;
      default = "sftp-users";
    };
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/sftp";
    };
    startDir = lib.mkOption {
      type = lib.types.path;
      default = "/";
    };
    users = lib.mkOption {
      default = [ ];
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
            };
            keys = lib.mkOption {
              type = lib.types.listOf lib.types.str;
            };
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      users = mkUsers cfg.users;
      groups.${cfg.group} = { };
    };

    services.openssh = {
      sftpServerExecutable = "internal-sftp";
      extraConfig = ''
        Match Group ${cfg.group}
          ChrootDirectory ${cfg.dataDir}
          DisableForwarding yes
          ForceCommand ${config.services.openssh.sftpServerExecutable} -d ${cfg.startDir}
      '';
    };
  };
}
