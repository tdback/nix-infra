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

    historyControl = [
      "ignoredups"
      "ignorespace"
    ];

    sessionVariables = {
      LC_ALL = "en_US.UTF-8";
      LESSHISTFILE = "-";
      MANPAGER = "${lib.getExe pkgs.less} -R -Dd+r -Du+b --use-color";
    };

    shellAliases = {
      "r" = "fc -s";
      "mkdir" = "mkdir -p";
    };
  };
}
