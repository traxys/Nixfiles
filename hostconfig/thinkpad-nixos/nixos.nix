{
  boot.initrd = {
    luks.devices = {
      root = {
        device = "/dev/disk/by-uuid/6b407da2-2256-4167-93e8-a7bb7be18112";
        preLVM = true;
        allowDiscards = true;
      };
    };
  };
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "thinkpad-nixos";
    interfaces = {
      enp0s31f6.useDHCP = true;
      wlp4s0.useDHCP = true;
    };
  };

  users = {
    users.traxys.uid = 1000;
    users.sf-user = {
      uid = 1100;
      group = "sf-user";
      isSystemUser = true;
    };
    groups.sf-user.gid = 1100;
    extraGroups.vboxusers.members = ["traxys"];
  };

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
