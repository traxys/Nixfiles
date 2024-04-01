{
  config,
  pkgs,
  ...
}: {
  home.username = "${config.extraInfo.username}";
  home.homeDirectory = "/home/${config.extraInfo.username}";

  home.packages = with pkgs; [
    jellyfin-media-player
    freetube
    spotify
    streamlink-twitch-gui-bin
  ];

  home.sessionVariables = {
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = 1;
  };

  home.stateVersion = "23.11";
}
