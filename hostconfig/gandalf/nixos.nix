{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "amd_pstate=active" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.resumeDevice = "/dev/disk/by-uuid/6993932f-5b29-4207-915a-2f185ec9f485";

  services.logind.lidSwitch = "suspend-then-hibernate";
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1h
  '';

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

  system.stateVersion = "24.05";
}
