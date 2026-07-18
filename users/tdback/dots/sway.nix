{
  lib,
  pkgs,
  ...
}:
let
  foot = lib.getExe pkgs.foot;
  tofi = "${lib.getExe' pkgs.tofi "tofi-drun"} | ${lib.getExe' pkgs.findutils "xargs"} ${swaymsg} exec --";
  grim = lib.getExe pkgs.grim;
  slurp = lib.getExe pkgs.slurp;
  wpctl = lib.getExe' pkgs.wireplumber "wpctl";

  swaymsg = lib.getExe' pkgs.sway "swaymsg";
  swaylock = "${lib.getExe pkgs.swaylock} -f -c 000000";

  swayIdle = pkgs.writeShellScript "sway-idle.sh" ''
    ${lib.getExe pkgs.swayidle} \
      before-sleep '${swaylock}' \
      timeout 180 '${swaylock}' \
      timeout 300 '${swaymsg} "output * dpms off"' \
      resume '${swaymsg} "output * dpms on"'
  '';

  swayStatus = pkgs.writeShellScript "sway-status.sh" ''
    while true; do
      battery="$(cat /sys/class/power_supply/BAT0/capacity)"
      time="$(date '+%Y-%m-%d')"
      volume="$(${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | ${lib.getExe pkgs.gawk} '{ print $NF * 100 }')"

      printf "VOL: %3d%% | %s | [%2s%%]" "$volume" "$time" "$battery"
      sleep 1
    done
  '';
in
{
  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    config = rec {
      terminal = foot;
      startup = [
        {
          command = "exec ${swayIdle}";
          always = true;
        }
      ];
      input = {
        "type:touchpad".natural_scroll = "enabled";
        "type:keyboard" = {
          xkb_options = "ctrl:swapcaps";
          repeat_delay = "350";
          repeat_rate = "40";
        };
      };
      modifier = "Mod4";
      keybindings = {
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";
        "${modifier}+b" = "splith";
        "${modifier}+v" = "splitv";
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+space" = "floating toggle";
        "${modifier}+Tab" = "workspace back_and_forth";
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+q" = "exec ${swaymsg} exit";
        "${modifier}+Shift+c" = "kill";
        "${modifier}+Alt+l" = "exec ${swaylock}";
        "${modifier}+Shift+Return" = "exec ${foot}";
        "Alt+space" = "exec ${tofi}";
        "${modifier}+p" = "exec ${grim}";
        "${modifier}+Shift+p" = "exec ${grim} -g \"$(${slurp})\"";
        "XF86AudioLowerVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.01-";
        "XF86AudioRaiseVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.01+ --limit 1.0";
        "XF86AudioMute" = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };
      focus.followMouse = "always";
      gaps.smartBorders = "on";
      window = {
        titlebar = false;
        border = 2;
      };
      bars = [
        {
          mode = "dock";
          position = "top";
          statusCommand = "${swayStatus}";
          fonts = {
            names = [ "Terminess Nerd Font Mono" ];
            size = 9.0;
          };
        }
      ];
    };
  };
}
