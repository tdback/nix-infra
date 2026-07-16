{
  lib,
  pkgs,
  ...
}:
{
  programs.bash = {
    enable = true;
    initExtra = ''
      PS1="\[\e[34m\]\w \[\e[33m\]$\[\e[0m\] "
      set -o vi
      set -o noclobber
    '';

    logoutExtra = "clear";

    sessionVariables = {
      LC_ALL = "en_US.UTF-8";
      LESSHISTFILE = "-";
      MANPAGER = "${lib.getExe pkgs.less} -R -Dd+r -Du+b --use-color";
    };

    historyControl = [
      "ignoredups"
      "ignorespace"
    ];
  };
}
