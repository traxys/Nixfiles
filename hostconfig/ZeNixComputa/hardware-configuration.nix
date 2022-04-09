# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = ["dm-snapshot"];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/62ddc566-fac0-4461-be44-0deb96c40b34";
    fsType = "btrfs";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/2f50d18f-1efd-4cc4-aae9-9f64f15585e3";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/564B-4D0E";
    fsType = "vfat";
  };
  fileSystems."/longstorage" = {
    device = "/dev/disk/by-uuid/15a593ec-7197-46f8-aeeb-004f1f3322e2";
    fsType = "btrfs";
  };

  fileSystems."/oldhome" = {
    device = "/dev/disk/by-uuid/611ae8bc-1f5a-4be8-86b6-fae42d183c0f";
    fsType = "ext4";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/91c2f707-02a2-4b0b-a683-42d70751e5b9";}
  ];
}