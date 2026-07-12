{
  config,
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user = rec {
        name = config.home.username;
        email = config.accounts.email.accounts.${name}.address or "tyler@tdback.net";
      };
    };
  };
}
