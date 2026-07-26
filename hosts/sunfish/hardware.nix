{
  hardware.cpu.amd.updateMicrocode = true;

  boot.kernelModules = [ "kvm-amd" ];
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/" = {
    device = "rpool/ROOT/nixos";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/nix" = {
    device = "rpool/nix";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var" = {
    device = "rpool/var";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/lib" = {
    device = "rpool/var/lib";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/var/log" = {
    device = "rpool/var/log";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };
}
