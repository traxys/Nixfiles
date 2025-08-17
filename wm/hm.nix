{ niri }:
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
    niri.homeModules.niri
    ./niri.nix
  ];

  options = {
    traxys.wm = lib.mkOption {
      type = lib.types.enum [
        "sway"
        "niri"
      ];
    };
    traxys.pkgs.niri-unstable = lib.mkOption {
      type = lib.types.package;
      default = niri.packages.${pkgs.system}.niri-unstable;
    };
    traxys.pkgs.xwayland-satellite-unstable = lib.mkOption {
      type = lib.types.package;
      default = niri.packages.${pkgs.system}.xwayland-satellite-unstable;
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
      package = pkgs.rofi-wayland;
      theme = "solarized_alternate";
      terminal = "${config.terminal.command}";
    };

    services.mako = {
      enable = true;
      settings = {
        font = "hack nerd font 10";
        margin = "20,20,5,5";
        default-timeout = 7000;
        "mode=do-not-disturb" = {
          invisible = 1;
        };
      };
    };

  };
}
