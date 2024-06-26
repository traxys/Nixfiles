{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "minus";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 1234 ];
  networking.firewall.allowedUDPPorts = [ 5353 ];
  networking.interfaces.enp1s0.wakeOnLan.enable = true;
  time.timeZone = "Europe/Paris";
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

  services.xserver = {
    layout = "us";
    xkbVariant = "dvp";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."${config.extraInfo.username}" = {
    isNormalUser = true;
    description = "Quentin";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  services.flatpak.enable = true;
  #hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.moonlight-qt
    pkgs.jstest-gtk
    (pkgs.kodi.withPackages (
      p: with p; [
        jellyfin
        youtube
        inputstream-adaptive
        steam-launcher
        netflix
      ]
    ))
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "traxys";

  programs.kdeconnect.enable = true;

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;
  system.stateVersion = "23.11";
  hardware.xpadneo.enable = true;

  hardware.bluetooth.enable = true;

  hardware.enableRedistributableFirmware = true;
}
