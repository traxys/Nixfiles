{
  callPackage,
  sources,
  naersk,
}: rec {
  wowup = callPackage ./wowup.nix {};
  simulationcraft = callPackage ./simulationcraft.nix {simulationcraft-src = sources.simulationcraft;};
  proton-ge = callPackage ./proton-ge.nix {};
  hbw = callPackage ./hbw {};
  kabalist_cli = callPackage ./kabalist.nix {
    inherit naersk;
    kabalist-src = sources.kabalist;
  };
  warcraftlogs = callPackage ./warcraftlogs.nix {};
  frg = callPackage ./frg.nix {};
  bonnie = callPackage ./bonnie {};
  perseus-cli = callPackage ./perseus {inherit bonnie;};
  flex-launcher = callPackage ./flex-launcher.nix {};
  mesonlsp = callPackage ./mesonlsp {};
}
