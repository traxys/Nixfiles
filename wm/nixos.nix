{ niri }:
{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    traxys.wm = lib.mkOption {
      type = lib.types.enum [
        "sway"
        "niri"
      ];
    };
  };

  config = {
    xdg.portal = {
      enable = true;
      config = lib.mkIf (config.traxys.wm == "sway") {
        sway = {
          default = "gtk";
          "org.freedesktop.impl.portal.Screenshot" = "wlr";
          "org.freedesktop.impl.portal.ScreenCast" = "wlr";
        };
      };

      extraPortals = lib.mkMerge [
        (lib.mkIf (config.traxys.wm == "sway") (
          with pkgs;
          [
            xdg-desktop-portal-wlr
            xdg-desktop-portal-gtk
          ]
        ))
        (lib.mkIf (config.traxys.wm == "niri") (with pkgs; [ xdg-desktop-portal-gnome ]))
      ];

      configPackages = lib.mkIf (config.traxys.wm == "niri") [ pkgs.niri-unstable ];
    };

    nixpkgs.overlays = [
      niri.overlays.niri
      (self: super: {
        cage = pkgs.writeShellScriptBin "cage" ''
          export XKB_DEFAULT_LAYOUT=fr
          export XKB_DEFAULT_VARIANT=ergol
          exec ${self.lib.getExe super.cage} "$@"
        '';
      })
    ];

    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;
    systemd.user.services.niri-flake-polkit = lib.mkIf (config.traxys.wm == "niri") {
      description = "PolicyKit Authentication Agent provided by niri-flake";
      wantedBy = [ "niri.service" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    services.displayManager.sessionPackages =
      (lib.optional (config.traxys.wm == "sway") pkgs.sway)
      ++ (lib.optional (config.traxys.wm == "niri") pkgs.niri-unstable);

    programs.regreet = {
      enable = true;

      theme.package = pkgs.canta-theme;

      settings = {
        background.path = pkgs.fetchurl {
          url = "https://lesmondaines.com/wp-content/uploads/2018/07/lac-crozet-rando-2.jpg";
          hash = "sha256-s35RoLnAyGhDNJh5+qbDEqCM7gF3U2Tyzx4X7jzhT70=";
        };
        GTK = {
          application_prefer_dark_theme = true;
        };
      };
    };
  };
}
