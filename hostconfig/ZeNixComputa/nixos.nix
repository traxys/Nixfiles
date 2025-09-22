{ pkgs, lib, ... }:
{
  boot.initrd = {
    enable = true;
    availableKernelModules = [
      "r8169"
    ];

    kernelModules = [ "amdgpu" ];

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

  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
  };

  networking = {
    hostName = "ZeNixComputa";
    interfaces = {
      enp4s0 = {
        useDHCP = true;
        wakeOnLan.enable = true;
      };
    };
    firewall.allowedTCPPorts = [
      8080
      8085
      5201
      7777
      24642
      80
      443
      843
      38202
      38203
      8554
      1935
      8888
      8889
      8890
    ];
    firewall.allowedUDPPorts = [
      24642
      80
      443
      843
      38202
      38203
      8000
      8001
      8002
      8003
    ];
  };

  time.timeZone = "Europe/Paris";

  users.users = {
    traxys.uid = 1000;
    guest = {
      isNormalUser = true;
      home = "/home/guest";
    };
  };

  services.mediamtx = {
    enable = true;
    settings = {
      authMethod = "internal";
      authInternalUsers = [
        {
          user = "any";
          pass = "";
          ips = [ ];
          permissions = [
            {
              action = "publish";
              path = "";
            }
            {
              action = "read";
              path = "";
            }
            {
              action = "playback";
              path = "";
            }
          ];
        }
      ];
      paths = {
        traxys = { };
      };
    };
  };

  hardware.ckb-next.enable = true;

  services.postgresql = {
    package = pkgs.postgresql_16;
    enable = true;
    ensureUsers = [ { name = "traxys"; } ];
    ensureDatabases = [
      "list"
      "regalade"
    ];
  };

  hardware.cpu.amd.updateMicrocode = true;

  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
