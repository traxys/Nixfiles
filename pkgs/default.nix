{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      self',
      naersk',
      ...
    }:
    {
      packages = {
        wowup = pkgs.callPackage ./wowup.nix { };
        simulationcraft = pkgs.callPackage ./simulationcraft.nix {
          simulationcraft-src = inputs.simulationcraft;
        };
        proton-ge = pkgs.callPackage ./proton-ge.nix { };
        hbw = pkgs.callPackage ./hbw { };
        kabalist_cli = pkgs.callPackage ./kabalist.nix {
          naersk = naersk';
          kabalist-src = inputs.kabalist;
        };
        warcraftlogs = pkgs.callPackage ./warcraftlogs.nix { };
        frg = pkgs.callPackage ./frg.nix { };
        bonnie = pkgs.callPackage ./bonnie { };
        perseus-cli = pkgs.callPackage ./perseus { inherit (self'.packages) bonnie; };
        flex-launcher = pkgs.callPackage ./flex-launcher.nix { };
        mesonlsp = pkgs.callPackage ./mesonlsp { };
        push-to-talk = pkgs.callPackage ./push-to-talk.nix { };
      };
    };
}
