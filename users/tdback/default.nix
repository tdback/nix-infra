{
  imports = [
    ./dots/git.nix
    ./dots/shell.nix
  ];

  programs.home-manager.enable = true;

  home = {
    username = "tdback";
    homeDirectory = "/home/tdback";
    stateVersion = "24.11";
  };
}
