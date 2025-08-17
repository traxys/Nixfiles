{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./sway.nix
    ./waybar/hm.nix
  ];

  options = {
    traxys.wm = lib.mkOption {
      type = lib.types.enum [ "sway" ];
    };
  };

  config = {

    gtk = {
      enable = true;
      font = {
        name = "DejaVu Sans";
      };
      theme.name = "Adwaita";
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    home.packages = with pkgs; [ kdePackages.breeze ];

    qt = {
      enable = true;
      platformTheme.name = "qtct";
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      size = 24;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    programs.rofi = {
      enable = true;
      theme = "solarized_alternate";
      terminal = "${config.terminal.command}";
    };
  };
}
