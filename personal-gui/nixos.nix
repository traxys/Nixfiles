{
  pkgs,
  config,
  ...
}: {
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  services.gnome.gnome-keyring.enable = true;
  services.flatpak.enable = true;

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
  services.udev.packages = [pkgs.yubikey-personalization];

  security.pam.services.swaylock.text = ''
    auth include login
  '';

  services.printing = {
    enable = true;
    drivers = [pkgs.hplip pkgs.gutenprint pkgs.cnijfilter2];
  };
  hardware.sane.enable = true;
  services.avahi = {
    nssmdns = true;
    enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  users.users."${config.extraInfo.username}".extraGroups = ["adbusers" "scanner" "lp"];
}
