{
  lib,
  pkgs,
  ...
}:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "foot";
        shell = "${lib.getExe pkgs.bash}";
        login-shell = "no";
        font = "Terminess Nerd Font Mono:size=15";
      };
      scrollback.lines = 1000;
      mouse.hide-when-typing = "yes";
      bell.system = "no";
      colors-dark = {
        foreground = "EAEAEA";
        background = "000000";
      };
    };
  };
}
