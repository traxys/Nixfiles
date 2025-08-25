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
      gui
      personal-gui
      gaming
      de
    ];
    hmModules = with self.hmModules; [
      ./extra_info.nix
      ./hm.nix
      minimal
      personal-cli
      gui
      personal-gui
      gaming
      de
    ];
    unfreePackages = [
      "cnijfilter2"
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
      "discord"
      "spotify"
      "wowup-cf"
      "libXNVCtrl" # mangohud through bottles & heroic
      "vintagestory"
    ];
    permittedInsecurePackages = [
      # vintagestory
      "dotnet-runtime-7.0.20"
    ];
  };
}
