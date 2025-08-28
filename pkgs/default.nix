{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages = rec {
        simulationcraft = pkgs.callPackage ./simulationcraft.nix {
          simulationcraft-src = inputs.simulationcraft;
        };
        hbw = pkgs.callPackage ./hbw { };
        warcraftlogs = pkgs.callPackage ./warcraftlogs.nix { };
        frg = pkgs.callPackage ./frg.nix { };
        push-to-talk = pkgs.callPackage ./push-to-talk.nix { };
        pulse8-cec = pkgs.callPackage ./pulse8-cec.nix { };
        weakauras-companion = pkgs.callPackage ./weakauras-companion.nix { };
        wow-note = pkgs.callPackage ./wow-note { };
        rmc = pkgs.callPackage ./rmc.nix { };
        sarc = pkgs.callPackage ./sarc.nix { inherit rstb; };
        rstb = pkgs.callPackage ./rstb.nix { inherit oead; };
        oead = pkgs.callPackage ./oead.nix { };
        msbt = pkgs.python3.pkgs.callPackage ./msbt.nix { };
        msbt-python = pkgs.python3.withPackages (_: [ msbt ]);
        bars-to-bwav = pkgs.callPackage ./bars-to-bwav.nix { };
        vdo-ninja = pkgs.callPackage ./vdo-ninja.nix { };
      };
    };
}
