{ pkgs, ... }:
let
  swap = "/dev/disk/by-uuid/66d89c4f-6d79-4bb5-8d83-d53ea07a5fb0";
in
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "amd_pstate=active" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.resumeDevice = swap;

  services.logind.lidSwitch = "suspend-then-hibernate";
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1h
  '';

  swapDevices = [
    {
      device = swap;
      encrypted = {
        enable = true;
        label = "swap-dev";
        blkDev = "/dev/disk/by-uuid/54642cf7-2f34-4a75-9a6b-82a0df72d2bb";
      };
    }
  ];

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        energy_performance_preference = "power";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        energy_performance_preference = "performance";
        turbo = "auto";
      };
    };
  };

  networking.hostName = "gandalf";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";
  services.automatic-timezoned.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.traxys = {
    isNormalUser = true;
    description = "Quentin Boyer";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  programs.steam.enable = true;

  services.postgresql = {
    enable = true;
    ensureUsers = [
      {
        name = "traxys";
        ensureClauses = {
          superuser = true;
          createdb = true;
        };
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 9080 4713 ];

  system.stateVersion = "24.05";
}
