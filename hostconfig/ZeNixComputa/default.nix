{ self, makeMachine, ... }:
{
  flake.nixosConfigurations.ZeNixComputa = makeMachine {
    system = "x86_64-linux";
    user = "traxys";
    nixosModules = with self.nixosModules; [
      ./extra_info.nix
      ./hardware-configuration.nix
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
    unfreePackages = [
      "cnijfilter2"
      "steam"
      "steam-original"
      "steam-run"
      "discord"
      "spotify"
      "libXNVCtrl" # mangohud through bottles & heroic
    ];
  };
}
