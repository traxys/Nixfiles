{
  wayland-pipewire-idle-inhibit,
}:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./terminal
    wayland-pipewire-idle-inhibit
  ];

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

  terminal = {
    enable = true;
    kind = "foot";

    colors = {
      background = "1a1b26";
      foreground = "c0caf5";

      black = {
        normal = "15161e";
        bright = "414868";
      };
      red = {
        normal = "f7768e";
      };
      green = {
        normal = "9ece6a";
      };
      yellow = {
        normal = "e0af68";
      };
      blue = {
        normal = "7aa2f7";
      };
      magenta = {
        normal = "bb9af7";
      };
      cyan = {
        normal = "7dcfff";
      };
      white = {
        normal = "a9b1d6";
        bright = "c0caf5";
      };

      urls = "73daca";

      selection = {
        foreground = "c0caf5";
        background = "33467c";
      };
    };
    font = {
      family = "Hack Nerd Font Mono";
      size = lib.mkDefault 10;
    };
  };

  services.playerctld = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [ pkgs.firefoxpwa ];
  };

  services.wayland-pipewire-idle-inhibit = {
    enable = true;
    settings = {
      verbosity = "INFO";
      media_minimum_duration = 10;
      idle_inhibitor = "wayland";
    };
  };

  home.sessionVariables = {
    BROWSER = "firefox";
    NIXOS_OZONE_WL = 1;
    ANDROID_HOME = "${config.home.sessionVariables.XDG_DATA_HOME}/android";
  };

  programs.zathura.enable = true;
}
