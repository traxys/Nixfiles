{ config, pkgs, ... }:
{
  home.username = "${config.extraInfo.username}";
  home.homeDirectory = "/home/${config.extraInfo.username}";

  home.packages = with pkgs; [
    jellyfin-media-player
    freetube
    spotify
    streamlink-twitch-gui-bin
    firefox
  ];

  services.spotifyd = {
    enable = true;
    settings.global = {
      use_mpris = true;
      bitrate = 320;
      device_type = "t_v";
      zeroconf_port = 1234;
    };
  };

  home.sessionVariables = {
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = 1;
  };

  home.stateVersion = "23.11";
}
