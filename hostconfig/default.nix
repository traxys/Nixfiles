{
  self,
  inputs,
  flakeOverlays,
  ...
}:
{
  _module.args = {
    flakeOverlays = system: [
      inputs.nur.overlays.default
      inputs.rust-overlay.overlays.default
      inputs.nixgl.overlays.default
      (final: prev: self.packages.${system})
      (final: prev: inputs.nix-gaming.packages.${system})
    ];

    makeMachine =
      {
        system,
        user,
        nixosModules,
        hmModules,
        unfreePackages ? [ ],
        permittedInsecurePackages ? [ ],
      }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = nixosModules ++ [
          ../nixos/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          (
            { lib, ... }:
            {
              nixpkgs = {
                overlays = flakeOverlays system;
                config = {
                  allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfreePackages;
                  inherit permittedInsecurePackages;
                };
              };

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${user} = {
                  imports = hmModules ++ [ inputs.fioul.homeManagerModules.default ];
                };
                extraSpecialArgs = {
                  flake = self;
                };
              };
            }
          )
        ];
      };
  };

  imports = [
    ./ZeNixLaptop
    ./ZeNixComputa
    ./minus
    ./thinkpad-nixos
    ./gandalf
  ];
}
