{ pkgs, config, ... }:
{
  wsl.enable = true;
  wsl.defaultUser = "boyerq";

  security.pki.certificateFiles = [
    ./zscaler.crt
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  services.xserver = {
    enable = true;

    windowManager.i3 = {
      enable = true;

      extraPackages = with pkgs; [
        rofi
        polybar
      ];
    };
  };

  services.displayManager.defaultSession = "none+i3";

  services.nixseparatedebuginfod2.enable = true;
  environment.enableDebugInfo = true;

  virtualisation.libvirtd = {
    enable = true;
    nss.enable = true;
  };

  users.users.boyerq = {
    extraGroups = [
      "podman"
      "libvirtd"
    ];
  };

  traxys.wm = "niri";

  system.stateVersion = "26.05";
}
