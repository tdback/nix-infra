{
  inputs,
  config,
  lib,
  pkgs,
  desktop,
  ...
}:
let
  pushover = pkgs.writeShellScriptBin "pushover" ''
    while getopts ":t:" args; do
      case "$args" in
        t)
          title="$OPTARG"
          ;;
        :)
          echo "missing option for argument -$OPTARG" >&2
          exit 1
          ;;
        *)
          echo "invalid option -$OPTARG" >&2
          exit 1
          ;;
      esac
    done
    shift $((OPTIND - 1))

    token="$(cat ${config.age.secrets.pushoverToken.path})"
    user="$(cat ${config.age.secrets.pushoverUser.path})"

    message="$*"
    : "''${message:="No errors to report."}"

    ${lib.getExe pkgs.curl} -s \
      --form-string "token=$token" \
      --form-string "user=$user" \
      --form-string "title=$title" \
      --form-string "message=$message" \
      https://api.pushover.net/1/messages.json
  '';
in
{
  config = lib.mkIf (!desktop) {
    environment.systemPackages = [ pushover ];
    age.secrets = {
      pushoverToken.file = "${inputs.self}/secrets/pushover-token.age";
      pushoverUser.file = "${inputs.self}/secrets/pushover-user.age";
    };
  };
}
