{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./terminal ];

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
}
