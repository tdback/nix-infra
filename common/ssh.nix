{
  config,
  lib,
  desktop,
  ...
}:
{
  config = lib.mkIf (!desktop) {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        AllowUsers =
          let
            users = config.users.users;
          in
          lib.filter (user: lib.elem "wheel" users.${user}.extraGroups) (lib.attrNames users);
      };
      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          comment = "${config.networking.hostName}.local";
          type = "ed25519";
          rounds = 100;
        }
      ];
    };
  };
}
