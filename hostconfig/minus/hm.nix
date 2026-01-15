{ config, pkgs, ... }:
{
  home.username = "${config.extraInfo.username}";
  home.homeDirectory = "/home/${config.extraInfo.username}";

  home.packages = with pkgs; [
    freetube
    spotify
    streamlink-twitch-gui-bin
    firefox
    deezer-enhanced
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

  systemd.user.services.waydroid-session = {
    Unit = {
      Description = "Waydroid Session Service";
      After = "default.target";
      Requires = "default.target";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };

    Service =
      let
        exe = "/run/current-system/sw/bin/waydroid";
      in
      {
        Type = "simple";
        ExecStart = "${exe} session start";
        ExecStop = "${exe} session stop";
        Restart = "always";
        RestartSec = "1s";
        WorkingDirectory = "/home/%u";
      };
  };

  home.stateVersion = "23.11";
}
