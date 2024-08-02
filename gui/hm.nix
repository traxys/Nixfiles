{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./wm ];

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

  home.packages = with pkgs; [
    # IM
    (discord.override { inherit (pkgs) nss; })
    element-desktop
    signal-desktop

    # Mail
    thunderbird

    # Media
    gromit-mpx
    krita
    pavucontrol
    spotify
    vlc

    # Office suite
    hunspell
    hunspellDicts.fr-any
    hyphen
    libreoffice
    onlyoffice-bin_latest

    # Misc
    eog
    # Broken as of 15 July
    # freecad
    wdisplays
    wl-clipboard
    xdg-utils
    fzf
    waypipe
  ];

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [ pkgs.firefoxpwa ];
  };

  home.sessionVariables = {
    BROWSER = "firefox";
    NIXOS_OZONE_WL = 1;
    ANDROID_HOME = "${config.home.sessionVariables.XDG_DATA_HOME}/android";
  };

  programs.zathura.enable = true;

  programs.rofi = {
    enable = true;
    theme = "solarized_alternate";
    terminal = "${config.terminal.command}";
  };
}
