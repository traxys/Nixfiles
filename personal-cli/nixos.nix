{ pkgs, config, ... }:
{
  environment.systemPackages = [
    config.boot.kernelPackages.perf
    pkgs.virt-manager
  ];

  networking.nameservers = [ 
    "familleboyer.net"
  ];

  services.resolved = {
    enable = true;
    dnsovertls = "opportunistic";
  };

  services.privoxy.enable = true;

  services.fwupd.enable = true;
  services.openssh.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };

    podman.enable = true;
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };

  services.tailscale.enable = true;

  networking.networkmanager.enable = true;

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  users.users."${config.extraInfo.username}".extraGroups = [
    "tss"
    "networkmanager"
    "libvirtd"
    "kvm"
    "qemu-libvirtd"
    "docker"
  ];
}
