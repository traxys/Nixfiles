{pkgs, ...}: {
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

  boot.kernelParams = ["intel_iommu=on" "iommu=pt"];

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

  virtualisation.containers = {
    enable = true;
    registries = {
      search = ["registry.sf.bds.atos.net" "docker.io" "quay.io"];
    };
  };

  systemd.services.roaming_proxy = {
    description = "Roaming Http Proxy";
    serviceConfig = {
      ExecStart = "${pkgs.roaming_proxy}/bin/roaming_proxy --config ${./roaming.toml}";
      Restart = "on-failure";
    };
    wantedBy = ["default.target"];
  };
  systemd.services.roaming_proxy.enable = true;

  services.privoxy.settings = {
    forward-socks5 = "/ localhost:9080 .";
  };

  security.sudo.extraConfig = ''Defaults env_keep += "*_proxy *_PROXY"'';
  networking.proxy = {
    httpProxy = "http://localhost:8100";
    httpsProxy = "http://localhost:8100";
    noProxy = "127.0.0.1,localhost,10.197.128.229,20.79.200.10,integration.frec.bull.fr,172.16.118.8";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
