{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    {
      packages = {
        simulationcraft = pkgs.callPackage ./simulationcraft.nix {
          simulationcraft-src = inputs.simulationcraft;
        };
        hbw = pkgs.callPackage ./hbw { };
        warcraftlogs = pkgs.callPackage ./warcraftlogs.nix { };
        frg = pkgs.callPackage ./frg.nix { };
        bonnie = pkgs.callPackage ./bonnie { };
        perseus-cli = pkgs.callPackage ./perseus { inherit (self'.packages) bonnie; };
        flex-launcher = pkgs.callPackage ./flex-launcher.nix { };
        push-to-talk = pkgs.callPackage ./push-to-talk.nix { };
        pulse8-cec = pkgs.callPackage ./pulse8-cec.nix { };
        weakauras-companion = pkgs.callPackage ./weakauras-companion.nix { };
        wow-note = pkgs.callPackage ./wow-note { };
        rmc = pkgs.callPackage ./rmc.nix { };
      };
    };
}
