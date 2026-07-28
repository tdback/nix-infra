{
  config,
  lib,
  ...
}:
{
  # Require a sudo password for interactive logins.
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = (config.users.users.tdback.hashedPasswordFile != null);

  # Prevent the running kernel from being replaced via kexec.
  security.protectKernelImage = lib.mkDefault true;

  # When enabled, after the system has fully initialized, all kernel module
  # loading is disabled until a subsequent boot.
  security.lockKernelModules = lib.mkDefault false;

  # Allow SMT and don't force-enable PTI; neither are a major concern in
  # single-user environments.
  security.allowSimultaneousMultithreading = true;
  security.forcePageTableIsolation = false;

  # Sandboxing.
  security.allowUserNamespaces = true;
  security.unprivilegedUsernsClone = true;

  # Prevent privilege escalation via kernel parameters.
  boot.loader.systemd-boot.editor = false;
}
