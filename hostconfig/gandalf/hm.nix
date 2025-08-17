{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.git = {
    userName = "Quentin Boyer";
    userEmail = config.extraInfo.email;
  };

  systemd.user.services = {
    "rclone-boh-articles" = {
      Unit = {
        Description = "rclone: BoH website articles";
        Documentation = "man:rclone(1)";
        After = "network-online.target";
        Wants = "network-online.target";
      };
      Service = {
        Type = "notify";
        ExecStartPre = "-${lib.getExe' pkgs.coreutils "mkdir"} -p %h/mnt/boh-articles";
        ExecStart = ''
          ${lib.getExe pkgs.rclone} \
            --config=%h/.config/rclone/rclone.conf \
            --log-level INFO \
            mount drive:Traxys %h/mnt/boh-articles \
            --drive-shared-with-me
        '';
        ExecStop = "/run/wrappers/bin/fusermount -u %h/mnt/boh-articles";
        Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
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
