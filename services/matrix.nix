{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.services.matrix;
  fqdn = "matrix.${cfg.domain}";
  fqdn' = "https://${fqdn}";

  element = pkgs.element-web.override {
    conf = {
      default_server_config."m.homeserver".base_url = fqdn';
    };
  };
in
{
  options.my.services.matrix = {
    enable = lib.mkEnableOption "matrix";
    domain = lib.mkOption {
      type = lib.types.str;
      default = config.networking.domain;
    };
    webClient = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.registrationToken = {
      file = "${inputs.self}/secrets/matrix-registration-token.age";
      owner = config.services.matrix-tuwunel.user;
      group = config.services.matrix-tuwunel.group;
    };

    services.matrix-tuwunel = {
      enable = true;
      settings.global = {
        server_name = cfg.domain;
        allow_encryption = true;
        allow_federation = true;
        allow_registration = true;
        registration_token_file = config.age.secrets.registrationToken.path;
        trusted_servers = [ "matrix.org" ];
      };
    };

    services.caddy.virtualHosts = lib.mkMerge [
      {
        ${fqdn}.extraConfig = ''
          reverse_proxy http://localhost:${builtins.toString config.services.matrix-tuwunel.settings.global.port}
        '';

        ${cfg.domain}.extraConfig = ''
          @matrix path /.well-known/matrix/*
          header @matrix {
              Access-Control-Allow-Origin "*"
              Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
              Access-Control-Allow-Headers "X-Requested-With, Content-Type, Authorization"
              Content-Type "application/json"
          }
          respond /.well-known/matrix/client `{"m.homeserver":{"base_url":"${fqdn'}"}}`
          respond /.well-known/matrix/server `{"m.server":"${fqdn}:${builtins.toString config.services.caddy.httpsPort}"}`
        '';
      }

      (lib.mkIf cfg.webClient {
        "element.${cfg.domain}".extraConfig = ''
          root * ${element}
          file_server
        '';
      })
    ];
  };
}
