{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    bottles
    # TODO: heroic is broken (see nixos/nixpkgs#264156)
    # heroic
    lutris
    simulationcraft
    warcraftlogs
    wine-tkg
    winetricks
    wowup
    xivlauncher
  ];

  home.file = {
    ".config/heroic/tools/wine/wine-system" = {
      source = pkgs.wine-tkg;
      #recursive = true;
    };
  };

  home.activation = {
    proton-ge = lib.hm.dag.entryAfter ["writeBoundary"] ''
      target="${config.home.homeDirectory}/.steam/root/compatibilitytools.d/Proton-${pkgs.proton-ge.version}"
      if ! [ -d "$target" ]; then
        cp -R ${pkgs.proton-ge} "$target"
        chmod -R u+w "$target"
      fi
    '';
  };
}
