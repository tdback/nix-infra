{
  config,
  lib,
  pkgs,
  desktop,
  ...
}:
let
  motd = pkgs.writeShellScriptBin "motd" ''
    BOLD="\e[1m"
    RESET="\e[0m"

    RELEASE="$(awk -F= '/PRETTY_NAME/ { print $2 }' /etc/os-release | tr -d '"')"
    KERNEL="$(uname -rs)"
    CPU="$(awk '{ print $1 ", " $2 ", " $3 }' /proc/loadavg)"
    MEMORY="$(free -m | awk 'NR == 2 { printf "%s/%sMiB (%.2f%%)\n", $3, $2, ($3 * 100) / $2 }')"

    UPTIME="$(cut -d '.' -f 1 /proc/uptime)"
    DAYS="$((UPTIME / 60 / 60 / 24))"
    HOURS="$((UPTIME / 60 / 60 % 24))"
    MINUTES="$((UPTIME / 60 % 60))"
    SECONDS="$((UPTIME % 60))"

    case "$(TZ="America/Detroit" date '+%H')" in
      0[0-9]|1[0-1])
        TIME="morning"
        ;;
      1[2-6])
        TIME="afternoon"
        ;;
      *)
        TIME="evening"
        ;;
    esac

    printf "\n"
    printf "''${BOLD}Good $TIME $(whoami), welcome to $(hostname)!$RESET\n"
    printf "\n"

    ${lib.strings.concatStrings (
      lib.lists.forEach (lib.attrNames config.networking.interfaces) (
        interface:
        "printf \"$BOLD  * %-20s$RESET %s\\n\" \"IPv4 ${interface}\" \\
          \"$(ip -4 addr show ${interface} | grep -oP '(?<=inet\\s)\\d+(\\.\\d+){3}')\"\n"
      )
    )}

    printf "$BOLD  * %-20s$RESET %s\n" "Release" "$RELEASE"
    printf "$BOLD  * %-20s$RESET %s\n" "Kernel" "$KERNEL"
    printf "\n"
    printf "$BOLD  * %-20s$RESET %s\n" "CPU Usage" "$CPU (1, 5, 15 min)"
    printf "$BOLD  * %-20s$RESET %s\n" "Memory Usage" "$MEMORY"
    printf "$BOLD  * %-20s$RESET %s\n" "System Uptime" "$DAYS days $HOURS hours $MINUTES minutes $SECONDS seconds"
    printf "\n"
  '';
in
{
  config = lib.mkIf (!desktop) {
    environment.systemPackages = [ motd ];

    programs.bash.loginShellInit = ''
      [ -z "$PS1" ] && return
      if command -v motd &> /dev/null; then
        motd
      fi
    '';
  };
}
