{ self, makeMachine, ... }:
{
  flake.nixosConfigurations.gandalf = makeMachine {
    system = "x86_64-linux";
    user = "traxys";
    nixosModules = with self.nixosModules; [
      ./extra_info.nix
      ./nixos.nix
      ./hardware-configuration.nix
      minimal
      personal-cli
      gui
      wm
      personal-gui
    ];
    hmModules = with self.hmModules; [
      ./extra_info.nix
      ./hm.nix
      minimal
      personal-cli
      gui
      wm
      personal-gui
    ];
    unfreePackages = [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "cnijfilter2"
      "spotify"
      "discord"
    ];
  };
}
