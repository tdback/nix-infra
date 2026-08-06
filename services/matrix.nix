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
  keyFile = "/run/livekit.key";
in
{
  options.my.services.matrix = {
    enable = lib.mkEnableOption "matrix";
    domain = lib.mkOption {
      type = lib.types.str;
      default = config.networking.domain;
    };
    webClient = lib.mkOption {
      default = { };
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          url = lib.mkOption {
            type = lib.types.str;
            default = "element.${cfg.domain}";
          };
        };
      };
    };
    rtc = lib.mkOption {
      default = { };
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          url = lib.mkOption {
            type = lib.types.str;
            default = "matrix-rtc.${cfg.domain}";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
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

        services.caddy.virtualHosts =
          let
            clientConfig = {
              "m.homeserver".base_url = "https://${fqdn}";
            }
            // (
              if cfg.rtc.enable then
                {
                  "org.matrix.msc4143.rtc_foci" = [
                    {
                      type = "livekit";
                      livekit_service_url = "https://${cfg.rtc.url}";
                    }
                  ];
                }
              else
                { }
            );
            serverConfig."m.server" = "${fqdn}:${builtins.toString config.services.caddy.httpsPort}";
          in
          lib.mkMerge [
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
                respond /.well-known/matrix/client `${builtins.toJSON clientConfig}`
                respond /.well-known/matrix/server `${builtins.toJSON serverConfig}`
              '';
            }

            (lib.mkIf cfg.webClient.enable {
              ${cfg.webClient.url}.extraConfig = ''
                header {
                    X-Frame-Options "SAMEORIGIN"
                    X-Content-Type-Options "nosniff"
                    X-XSS-Protection "1; mode=block"
                    Content-Security-Policy "frame-ancestors 'self'"
                }
                root * ${
                  pkgs.element-web.override {
                    conf = {
                      default_server_config."m.homeserver" = {
                        base_url = "https://${fqdn}";
                        server_name = cfg.domain;
                      };
                      element_call = {
                        use_exclusively = cfg.rtc.enable;
                        disabled = !cfg.rtc.enable;
                      };
                    };
                  }
                }
                file_server
              '';
            })
          ];
      }

      (lib.mkIf cfg.rtc.enable {
        services.livekit = {
          enable = true;
          openFirewall = true;
          settings.room.auto_create = false;
          inherit keyFile;
        };

        services.lk-jwt-service = {
          enable = true;
          livekitUrl = "wss://${cfg.rtc.url}";
          inherit keyFile;
        };

        systemd.services.livekit-key = {
          before = [
            "lk-jwt-service.service"
            "livekit.service"
          ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig.Type = "oneshot";
          unitConfig.ConditionPathExists = "!${keyFile}";
          path = with pkgs; [
            livekit
            coreutils
            gawk
          ];
          script = ''
            echo "livekit key missing, generating a new one..."
            echo "lk-jwt-service: $(livekit-server generate-keys | tail -1 | awk '{ print $3 }')" > "${keyFile}"
          '';
        };

        systemd.services.lk-jwt-service.environment.LIVEKIT_FULL_ACCESS_HOMESERVERS = cfg.domain;

        services.caddy.virtualHosts.${cfg.rtc.url}.extraConfig = ''
          @jwt_service {
              path /sfu/get* /healthz* /get_token*
          }
          handle @jwt_service {
              reverse_proxy http://localhost:${builtins.toString config.services.lk-jwt-service.port}
          }
          handle {
              reverse_proxy http://localhost:${builtins.toString config.services.livekit.settings.port} {
                  header_up Connection "upgrade"
                  header_up Upgrade {http.request.header.Upgrade}
              }
          }
        '';
      })
    ]
  );
}
