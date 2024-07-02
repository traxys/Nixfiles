{
  pkgs,
  config,
  lib,
  ...
}:
{
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
  };

  services.gnome.gnome-keyring.enable = true;
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    config = {
      sway = {
        default = "gtk";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
      };
    };

    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  programs.noisetorch.enable = true;

  programs.adb.enable = true;
  programs.dconf.enable = true;

  virtualisation.waydroid.enable = true;

  hardware.opentabletdriver.enable = true;
  hardware.bluetooth.enable = true;

  security.pam.yubico = {
    enable = true;
    debug = false;
    mode = "challenge-response";
  };
  services.udev.packages = with pkgs; [ yubikey-personalization ];

  security.pam.services.swaylock.text = ''
    auth include login
  '';

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      hplip
      gutenprint
      cnijfilter2
    ];
  };
  hardware.sane.enable = true;
  services.avahi = {
    nssmdns4 = true;
    enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  users.users."${config.extraInfo.username}".extraGroups = [
    "adbusers"
    "scanner"
    "lp"
  ];
}
