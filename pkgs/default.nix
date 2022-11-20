{
  callPackage,
  sources,
  naersk,
}: {
  oscclip = callPackage ./oscclip.nix {oscclip-src = sources.oscclip;};
  xdg-ninja = callPackage ./xdg-ninja.nix {xdg-ninja-src = sources.xdg-ninja;};
  wowup = callPackage ./wowup.nix {};
  simulationcraft = callPackage ./simulationcraft.nix {simulationcraft-src = sources.simulationcraft;};
  proton-ge = callPackage ./proton-ge.nix {proton-ge-src = sources.proton-ge;};
  kabalist_cli = callPackage ./kabalist.nix {
    inherit naersk;
    kabalist-src = sources.kabalist;
  };
}
