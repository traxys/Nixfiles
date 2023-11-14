{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    bottles
    heroic
    lutris
    simulationcraft
    warcraftlogs
    wine-tkg
    winetricks
    wowup
    xivlauncher
    obs-studio
    pulseaudio
  ];

  home.file = {
    ".config/heroic/tools/wine/wine-system" = {
      source = pkgs.wine-tkg;
      #recursive = true;
    };
  };

  home.activation = {
    proton-ge = lib.hm.dag.entryAfter ["writeBoundary"] ''
      target="${config.home.homeDirectory}/.steam/root/compatibilitytools.d/Proton-${lib.getVersion pkgs.proton-ge}"
      if ! [ -d "$target" ]; then
        cp -R ${pkgs.proton-ge} "$target"
        chmod -R u+w "$target"
      fi
    '';
  };
}
