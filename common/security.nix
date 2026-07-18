{
  config,
  ...
}:
{
  # require a password for interactive logins
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = (config.users.users.tdback.hashedPasswordFile != null);

  # prevent privilege escalation via kernel parameters
  boot.loader.systemd-boot.editor = false;
}
