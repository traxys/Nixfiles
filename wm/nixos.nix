{ pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    config = {
      sway = {
        default = "gtk";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
      };
    };

    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  nixpkgs.overlays = [
    (self: super: {
      cage = pkgs.writeShellScriptBin "cage" ''
        export XKB_DEFAULT_LAYOUT=fr
        export XKB_DEFAULT_VARIANT=ergol
        exec ${self.lib.getExe super.cage} "$@"
      '';
    })
  ];

  services.displayManager.sessionPackages = with pkgs; [
    sway
  ];

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
}
