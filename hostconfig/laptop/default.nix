{ self, makeMachine, ... }:
{
  flake.nixosConfigurations.laptop = makeMachine {
    system = "x86_64-linux";
    user = "traxys";
    nixosModules = with self.nixosModules; [
      ./extra_info.nix
      ./nixos.nix
      ./hardware-configuration.nix
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
    unfreePackages = [
      "cnijfilter2"
      "spotify"
      "discord"
    ];
  };
}
