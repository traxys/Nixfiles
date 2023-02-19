{
  boot.initrd = {
    enable = true;
    availableKernelModules = ["amdgpu" "r8169"];

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
      enp4s0 = {
        useDHCP = true;
        wakeOnLan.enable = true;
      };
    };
  };

  time.timeZone = "Europe/Paris";

  users.users = {
    traxys.uid = 1000;
    guest = {
      isNormalUser = true;
      home = "/home/guest";
    };
  };

  hardware.ckb-next.enable = true;

  services.postgresql = {
    enable = true;
    ensureUsers = [
      {
        name = "traxys";
        ensurePermissions = {"DATABASE \"list\"" = "ALL PRIVILEGES";};
      }
    ];
    ensureDatabases = ["list"];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
