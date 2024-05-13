{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./wm ];

  home.packages = with pkgs; [
    # Browsers
    firefox-wayland
    (tor-browser-bundle-bin.override { useHardenedMalloc = false; })

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

    # Libreoffice
    hunspell
    hunspellDicts.fr-any
    hyphen
    libreoffice

    # Misc
    gnome.eog
    freecad
    plasma5Packages.kdeconnect-kde
    wdisplays
    wl-clipboard
    xdg-utils
    fzf
    waypipe
    glaurung
  ];

  home.sessionVariables = {
    BROWSER = "firefox";
    GTK_USE_PORTAL = 1;
    NIXOS_OZONE_WL = 1;
    ANDROID_HOME = "${config.home.sessionVariables.XDG_DATA_HOME}/android";
  };

  programs.zathura.enable = true;

  programs.rofi = {
    enable = true;
    theme = "solarized_alternate";
    terminal = "${config.terminal.command}";
  };

  xdg.desktopEntries.zklist = {
    name = "zklist";
    exec = ''${pkgs.foot}/bin/foot nvim "+ZkNotes"'';
  };

  xdg.desktopEntries.zksearch = {
    name = "zksearch";
    exec = ''${pkgs.foot}/bin/foot nvim "+ZkNotes { match = { vim.fn.input('Search: ') } }"'';
  };
}
