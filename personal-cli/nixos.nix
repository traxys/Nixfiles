{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = [config.boot.kernelPackages.perf pkgs.virt-manager];

  services.privoxy.enable = true;

  services.fwupd.enable = true;
  services.openssh.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
      qemu.ovmf = {
        enable = true;
        packages = [pkgs.OVMFFull.fd];
      };
    };

    podman.enable = true;
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };

  services.tailscale.enable = true;

  networking.networkmanager.enable = true;

  users.users."${config.extraInfo.username}".extraGroups = [
    "networkmanager"
    "libvirtd"
    "kvm"
    "qemu-libvirtd"
    "docker"
  ];
}
