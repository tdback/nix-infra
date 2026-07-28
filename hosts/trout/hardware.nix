{
  hardware.cpu.intel.updateMicrocode = true;

  boot.kernelModules = [ "kvm-intel" ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Unlock LUKS partition at boot.
  boot.initrd.kernelModules = [ "cryptd" ];
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-label/CRYPTROOT";

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

  fileSystems."/home" = {
    device = "rpool/home";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };
}
