{
  callPackage,
  sources,
  naersk,
}: {
  oscclip = callPackage ./oscclip.nix {oscclip-src = sources.oscclip;};
  wowup = callPackage ./wowup.nix {};
  simulationcraft = callPackage ./simulationcraft.nix {simulationcraft-src = sources.simulationcraft;};
  proton-ge = callPackage ./proton-ge.nix {proton-ge-src = sources.proton-ge;};
  hbw = callPackage ./hbw {};
  kabalist_cli = callPackage ./kabalist.nix {
    inherit naersk;
    kabalist-src = sources.kabalist;
  };
  warcraftlogs = callPackage ./warcraftlogs.nix {warcraftlogs-src = sources.warcraftlogs;};
  dotacat = callPackage ./dotacat.nix {
    inherit naersk;
    dotacatSrc = sources.dotacat;
  };
  frg = callPackage ./frg.nix {};
  lemminx-bin = callPackage ./lemminx-bin.nix {};
}
