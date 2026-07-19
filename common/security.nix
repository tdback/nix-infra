{
  config,
  lib,
  ...
}:
{
  # require a password for interactive logins
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = (config.users.users.tdback.hashedPasswordFile != null);

  # prevent kexecing the running kernel
  security.protectKernelImage = lib.mkDefault true;

  # when enabled, after the system has fully initialized, all kernel module
  # loading is disabled until a subsequent boot
  security.lockKernelModules = lib.mkDefault false;

  # allow SMT and don't force-enable PTI; neither are a major concern in
  # single-user environments
  security.allowSimultaneousMultithreading = true;
  security.forcePageTableIsolation = false;

  # sandboxing
  security.allowUserNamespaces = true;
  security.unprivilegedUsernsClone = true;

  # prevent privilege escalation via kernel parameters
  boot.loader.systemd-boot.editor = false;
}
