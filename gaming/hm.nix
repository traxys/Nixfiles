{
  pkgs,
  config,
  lib,
  flake,
  ...
}:
let
  inherit (flake.inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}) wine-tkg;
in
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
    umu-launcher
    cage
    owmods-gui
    prismlauncher
  ];

  programs.mangohud = {
    enable = true;
  };

  home.file = {
    ".config/heroic/tools/wine/wine-system" = {
      source = wine-tkg;
      #recursive = true;
    };
  };
}
