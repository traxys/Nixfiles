{
  config,
  pkgs,
  lib,
  ...
}:
let
  cec-ctl = lib.getExe' pkgs.v4l-utils "cec-ctl";
in
{
  boot.extraModulePackages = [
    (pkgs.pulse8-cec.override { inherit (config.boot.kernelPackages) kernel; })
  ];
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

  services.udev.extraRules = ''
    SUBSYSTEM=="tty" ACTION=="add" \
      ATTRS{manufacturer}=="Pulse-Eight" ATTRS{product}=="CEC Adapter" \
      TAG+="systemd" ENV{SYSTEMD_WANTS}="pulse8-cec-attach@$devnode.service"

    SUBSYSTEM=="cec" KERNEL=="cec0" ACTION=="add" \
      TAG+="systemd" ENV{SYSTEMD_WANTS}="cec0-configure@card1-HDMI-A-1.service"

    SUBSYSTEM=="cec" KERNEL == "cec0" ACTION=="add" \
      RUN+="${cec-ctl} '--device=$devpath' '--osd-name=minus' --playback"
  '';

  systemd.services."pulse8-cec-attach@" = {
    description = "Configure USB Pulse-Eight serial device at %I";

    unitConfig = {
      ConditionPathExists = "%I";
    };

    serviceConfig =
      let
        systemdLinuxConsoleTools = pkgs.linuxConsoleTools.overrideAttrs (oa: {
          makeFlags = oa.makeFlags ++ [ "SYSTEMD_SUPPORT=1" ];
          buildInputs = oa.buildInputs ++ (with pkgs; [ systemdLibs ]);
        });
      in
      {
        Type = "forking";
        ExecStart = "${lib.getExe' systemdLinuxConsoleTools "inputattach"} --daemon --pulse8-cec %I";
      };
  };

  systemd.services."cec0-configure@" = {
    description = "Configure CEC adapter cec0 assuming it runs on output %i";
    unitConfig = {
      AssertPathExists = "/sys/class/drm/%i/edid";
      BindsTo = "dev-cec0.device";
    };

    serviceConfig = {
      Type = "exec";
      ExecStart = ''
        ${cec-ctl} --device=0 "--osd-name=%H" --playback "--phys-addr-from-edid-poll=/sys/class/drm/%i/edid"
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    moonlight-qt
    jstest-gtk
    libcec
    (kodi.withPackages (
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
