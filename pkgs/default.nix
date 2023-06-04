{
  callPackage,
  sources,
  naersk,
}: rec {
  wowup = callPackage ./wowup.nix {};
  simulationcraft = callPackage ./simulationcraft.nix {simulationcraft-src = sources.simulationcraft;};
  proton-ge = callPackage ./proton-ge.nix {proton-ge-src = sources.proton-ge;};
  hbw = callPackage ./hbw {};
  kabalist_cli = callPackage ./kabalist.nix {
    inherit naersk;
    kabalist-src = sources.kabalist;
  };
  warcraftlogs = callPackage ./warcraftlogs.nix {warcraftlogs-src = sources.warcraftlogs;};
  frg = callPackage ./frg.nix {};
  lemminx-bin = callPackage ./lemminx-bin.nix {};
  bonnie = callPackage ./bonnie {};
  perseus-cli = callPackage ./perseus {inherit bonnie;};
}
