{
  config,
  ...
}:
{
  # require a password for interactive logins
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = (config.users.users.tdback.hashedPasswordFile != null);
}
