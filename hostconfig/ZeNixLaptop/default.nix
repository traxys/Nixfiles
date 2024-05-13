{ self, makeMachine, ... }:
{
  flake.nixosConfigurations.ZeNixLaptop = makeMachine {
    system = "x86_64-linux";
    user = "traxys";
    nixosModules = with self.nixosModules; [
      ./extra_info.nix
      ./nixos.nix
      minimal
      personal-cli
      personal-gui
      gaming
    ];
    hmModules = with self.hmModules; [
      ./extra_info.nix
      ./hm.nix
      minimal
      personal-cli
      personal-gui
      gaming
    ];
  };
}
