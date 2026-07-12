{
  imports = [
    ./dots/git.nix
  ];

  programs.home-manager.enable = true;

  home = {
    username = "tdback";
    homeDirectory = "/home/tdback";
    stateVersion = "24.11";
  };
}
