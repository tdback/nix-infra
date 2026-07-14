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
  };
}
