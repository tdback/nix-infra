{
  imports = [
    ./dots/git.nix
    ./dots/nvim.nix
    ./dots/shell.nix
    ./dots/tmux.nix
  ];

  programs.home-manager.enable = true;

  home = {
    username = "tdback";
    homeDirectory = "/home/tdback";
    stateVersion = "24.11";
  };
}
