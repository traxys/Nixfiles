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

    # Misc progs
    bitwarden
    libreoffice-fresh
	kdeconnect

    # Misc utils
    wl-clipboard
    xdg_utils
    feh
  ];

  home.sessionVariables = {
    BROWSER = "firefox";
  };

  programs = {
    zathura = {
      enable = true;
    };
  };
}
