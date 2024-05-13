{ self, makeMachine, ... }:
{
  flake.nixosConfigurations.minus = makeMachine {
    system = "x86_64-linux";
    user = "traxys";
    nixosModules = with self.nixosModules; [
      ./extra_info.nix
      ./hardware-configuration.nix
      ./nixos.nix
      minimal
      personal-cli
    ];
    hmModules = with self.hmModules; [
      ./extra_info.nix
      ./hm.nix
      minimal
      personal-cli
    ];
  };
}
