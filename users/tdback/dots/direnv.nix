{
  config,
  ...
}:
{
  programs.direnv = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    nix-direnv.enable = true;
    config = {
      strict_env = true;
      warn_timeout = 0;
    };
  };
}
