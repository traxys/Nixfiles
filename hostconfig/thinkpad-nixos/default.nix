{
  self,
  makeMachine,
  hostOverlays,
  inputs,
  lib,
  ...
}:
{
  flake = {
    nixosConfigurations.thinkpad-nixos = makeMachine {
      system = "x86_64-linux";
      user = "traxys";
      nixosModules = with self.nixosModules; [
        ./extra_info.nix
        ./hardware-configuration.nix
        ./nixos.nix
        minimal
        personal-cli
        personal-gui
      ];
      hmModules = with self.hmModules; [
        ./extra_info.nix
        ./hm.nix
        minimal
        personal-cli
        personal-gui
      ];
    };

    homeConfigurations."boyerq@thinkpad-nixos" = inputs.home-manager.lib.homeManagerConfiguration {
      modules =
        (with self.hmModules; [
          minimal
          work
          personal-cli
          personal-gui
        ])
        ++ [
          ./extra_info.nix
          ./hm.nix
          inputs.fioul.homeManagerModules.default
          inputs.gsm.homeManagerModules.default
        ];

      pkgs = import inputs.nixpkgs rec {
        system = "x86_64-linux";

        overlays = hostOverlays system;
      };

      config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ ];
    };
  };
}
