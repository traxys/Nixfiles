{
  self,
  makeMachine,
  flakeOverlays,
  inputs,
  lib,
  ...
}:
{
    flake.nixosConfigurations.fabrial = makeMachine {
      system = "x86_64-linux";
      user = "boyerq";

      nixosModules = with self.nixosModules; [
	inputs.wsl.nixosModules.default
	./extra_info.nix
        ./nixos.nix
	minimal
	gui
	wm
      ];

      hmModules = with self.hmModules; [
	./extra_info.nix
        ./hm.nix
	minimal
	gui
	wm
      ];
    };
}
