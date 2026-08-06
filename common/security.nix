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

  boot.kernel.sysctl = {
    # Disable the magic SysRq key.
    "kernel.sysrq" = 0;

    # Reverse path filtering - prevents IP spoofing from DDoS attacks.
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;

    # Protect against SYN flood attacks.
    "net.ipv4.tcp_syncookies" = 1;

    # Protect against TIME-WAIT assassination hazards.
    "net.ipv4.tcp_rfc1337" = 1;

    # Disable source routing.
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;

    # Refuse ICMP redirects - mitigates MITM.
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;

    # Don't send ICMP redirects.
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;

    # Ignore ICMP broadcasts - mitigates SMURF.
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
  };
}
