{ pkgs, config, ... }:
{
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 5901 ];
    allowedTCPPortRanges = [
      {
        # KDE connect
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = [
      {
        # KDE connect
        from = 1714;
        to = 1764;
      }
    ];
  };

  fileSystems."/home/traxys/Photos/D3500" = {
    device = "/dev/disk/by-label/NIKON\\x20D3500";
    options = [
      "defaults"
      "noauto"
      "x-systemd.automount"
    ];
  };

  hardware.keyboard.qmk.enable = true;

  programs.adb.enable = true;

  security.pam.yubico = {
    enable = true;
    debug = false;
    mode = "challenge-response";
  };
  services.udev.packages = with pkgs; [ yubikey-personalization ];

  virtualisation.waydroid.enable = true;

  hardware.opentabletdriver.enable = true;

  hardware.bluetooth.enable = true;

  services.avahi = {
    nssmdns4 = true;
    enable = true;
  };

  users.users.${config.extraInfo.username}.extraGroups = [ "adbusers" ];
}
