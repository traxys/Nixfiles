{
  boot.initrd = {
    enable = true;
    availableKernelModules = ["amdgpu" "r8169"];
    luks = {
      yubikeySupport = true;

      devices = let
        yubikey = {
          slot = 2;
          twoFactor = false;
          storage.device = "/dev/disk/by-uuid/564B-4D0E";
        };
      in {
        nixos-root = {
          device = "/dev/disk/by-uuid/cca61c58-e022-47ad-b9fd-9af9d2fa8abb";
          preLVM = true;
        };
        nixos-home = {
          device = "/dev/disk/by-uuid/c21561bf-5714-4cd2-8f37-d5880f76910d";
          preLVM = true;
        };
        long-storage = {
          device = "/dev/disk/by-uuid/670bf56f-fd3d-4127-b598-6bde4d2f2c27";
          preLVM = true;
        };
        old-ssd = {
          device = "/dev/disk/by-uuid/35326fe8-b0ce-4939-bdf1-5b3e180ed057";
          preLVM = true;
        };
      };
    };

    # secrets = {
    #   "/etc/secrets/initrd/keyfile" = "/etc/secrets/initrd/keyfile";
    # };
    # kernelParams = [ "iomem=relaxed" ];
    network.ssh = {
      enable = true;
      port = 8022;
    };
  };
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  boot.kernelParams = [
    "video=HDMI-A-1:1920x1080@75"
    "video=DP-2:1920x1080@75"
  ];

  networking = {
    hostName = "ZeNixComputa";
    interfaces = {
      enp4s0.useDHCP = true;
    };
  };

  users.users = {
    traxys.uid = 1000;
    guest = {
      isNormalUser = true;
      home = "/home/guest";
    };
  };

  hardware.ckb-next.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
