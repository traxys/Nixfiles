{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./wm];

  home.packages = with pkgs; [
    # Browsers
    firefox-wayland
    (tor-browser-bundle-bin.override {
      useHardenedMalloc = false;
    })

    # IM
    (discord.override {nss = pkgs.nss;})
    element-desktop
    signal-desktop

    # Mail
    thunderbird-wayland

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
  ];

  home.sessionVariables = {
    BROWSER = "firefox";
    GTK_USE_PORTAL = 1;
  };

  programs.zathura.enable = true;

  home.file = {
    "bin/ssh-picker" = let
      ssh_hosts = builtins.attrNames config.programs.ssh.matchBlocks;
      ssh_specific = builtins.filter (h: !(lib.strings.hasInfix "*" h)) ssh_hosts;
      ssh_specific_echo = builtins.map (h: "echo ${h}") ssh_specific;

      picker =
        if config.wm.kind == "sway"
        then "${pkgs.wofi}/bin/wofi -S dmenu"
        else "${pkgs.rofi}/bin/rofi -dmenu";
    in {
      text = ''
        #!/usr/bin/env bash

        {
            ${lib.strings.concatStringsSep "\n" ssh_specific_echo}
        } | ${picker} | xargs ${config.terminal.command} ssh
      '';
      executable = true;
    };
  };
}
