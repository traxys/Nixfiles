{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    bottles
    heroic
    lutris
    simulationcraft
    warcraftlogs
    wine-tkg
    winetricks
    weakauras-companion
    wowup-cf
    xivlauncher
    obs-studio
    pulseaudio
    wow-note
  ];

  home.file = {
    ".config/heroic/tools/wine/wine-system" = {
      source = pkgs.wine-tkg;
      #recursive = true;
    };
  };
}
