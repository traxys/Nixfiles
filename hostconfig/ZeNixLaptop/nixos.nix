{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    initrd = {
      luks.devices = {
        root = {
          device = "/dev/disk/by-uuid/de0242ac-788a-44fc-a1ef-8d7bfaa448c6";
          preLVM = true;
          #keyFile = "/etc/secrets/initrd/keyfile";
          fallbackToPassword = true;
        };
        home = {
          device = "/dev/disk/by-uuid/b028c674-64c5-40e0-88c4-481d78854049";
          preLVM = true;
          #keyFile = "/etc/secrets/initrd/keyfile";
          fallbackToPassword = true;
        };
      };
      secrets = {
        "/etc/secrets/initrd/keyfile" = "/etc/secrets/initrd/keyfile";
      };
      #kernelParams = [ "iomem=relaxed" ];
    };
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        enableCryptodisk = true;
      };
    };
  };

  networking.hostName = "ZeNixLaptop";

  time.timeZone = "Europe/Paris";
  hardware.opengl.enable = true;

  system.stateVersion = "21.05";
}
