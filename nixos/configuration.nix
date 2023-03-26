# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./pkg.nix
    #./home.nix
    ./localcfg.nix
	./cachix.nix
  ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  security.rtkit.enable = true;
  services = {
    tzupdate.enable = true;
    privoxy.enable = true;
    flatpak.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    localtimed.enable = true;
    geoclue2.enable = true;
    fwupd.enable = true;
    postgresql = {
      enable = true;
    };
  };
  programs.adb.enable = true;
  programs.dconf.enable = true;
  programs.nix-ld.enable = true;
  hardware.opentabletdriver.enable = true;

  boot.kernelPackages = pkgs.linuxPackages;
  /*
  nixpkgs.config.allowBroken = true;
  */

  virtualisation = {
    waydroid.enable = true;
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
      qemu.ovmf = {
        enable = true;
        packages = [pkgs.OVMFFull];
      };
    };
    podman = {
      enable = true;
    };
    docker = {
      enable = true;
	  storageDriver = "btrfs";
    };
  };

  security.pam = {
    yubico = {
      enable = true;
      debug = false;
      mode = "challenge-response";
    };
    services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };

  networking.networkmanager.enable = true;
  programs.noisetorch.enable = true;

  networking.firewall = {
    allowedTCPPorts = [
      8080
      8085
      7878
      3724
    ];

    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
