{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # Browser
    firefox-wayland
    (tor-browser-bundle-bin.override {
      useHardenedMalloc = false;
    })

    # IM
    element-desktop
    (discord.override {nss = pkgs.nss;})
    signal-desktop

    # Mail
    thunderbird-wayland

    # Media
    pavucontrol
    vlc
    spotify

    # Libreoffice
    libreoffice
    hunspell
    hunspellDicts.fr-any
    hyphen

    # Misc progs
    bitwarden
    libreoffice-fresh
    kdeconnect

    # Misc utils
    wl-clipboard
    xdg_utils
    feh
  ];

  /* environment.pathsToLink = [ "/share/hunspell" "/share/myspell" "/share/hyphen" ];
    environment.variables.DICPATH = "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen"; */

  home.sessionVariables = {
    BROWSER = "firefox";
	GTK_USE_PORTAL = 1;
  };

  programs = {
    zathura = {
      enable = true;
    };
  };
}
