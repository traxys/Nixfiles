{
  self,
  makeMachine,
  flakeOverlays,
  inputs,
  lib,
  ...
}:
{
  flake = {
    homeConfigurations."boyerq@fabrial" = inputs.home-manager.lib.homeManagerConfiguration {
      modules =
        (with self.hmModules; [
          minimal
          work
          personal-cli
          gui
          wm
        ])
        ++ [
          ./extra_info.nix
          ./hm.nix
          inputs.fioul.homeManagerModules.default
          inputs.gsm.homeManagerModules.default
        ];

      pkgs = import inputs.nixpkgs rec {
        system = "x86_64-linux";

        overlays = flakeOverlays system;

        config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "slack"
            "discord"
            "spotify"
          ];
      };
    };
  };
}
