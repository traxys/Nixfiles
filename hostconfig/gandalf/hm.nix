{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.git = {
    settings.user.name = "Quentin Boyer";
    settings.user.email = config.extraInfo.email;
  };

  systemd.user.services =
    let
      mkRclone =
        {
          name,
          path,
          remote,
        }:
        {
          Unit = {
            Description = "rclone: ${name}";
            Documentation = "man:rclone(1)";
            After = "network-online.target";
            Wants = "network-online.target";
          };
          Service = {
            Type = "notify";
            ExecStartPre = "-${lib.getExe' pkgs.coreutils "mkdir"} -p %h/${path}";
            ExecStart = ''
              ${lib.getExe pkgs.rclone} \
                --config=%h/.config/rclone/rclone.conf \
                --log-level INFO \
                mount ${remote} %h/${path} \
                --drive-shared-with-me
            '';
            ExecStop = "/run/wrappers/bin/fusermount -u %h/${path}";
            Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
        };
    in
    {
      "rclone-boh-articles" = mkRclone {
        name = "BoH website articles";
        path = "mnt/boh-articles";
        remote = "drive:Traxys";
      };
      "rclone-nextcloud" = mkRclone {
        name = "Nextcloud";
        path = "mnt/nextcloud";
        remote = "nextcloud:";
      };
    };

  traxys.wm = "niri";

  traxys.waybar.modules.battery.enable = true;
  traxys.waybar.modules."network#wifi" = {
    enable = true;
    interface = "wlp2s0";
  };
  home.stateVersion = "24.11";
}
