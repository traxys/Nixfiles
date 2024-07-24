{ pkgs, config, ... }:
{
  networking.firewall = {
    enable = true;
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
