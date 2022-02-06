{
  description = "NixOS configuration";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nixpkgs-mozilla = {
        url = "github:mozilla/nixpkgs-mozilla";
        flake = false;
      };
      hm-nvim-traxys = {
        url = "github:traxys/home-manager-nvim-flake";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      zsh-traxys = {
        url = "github:traxys/zsh-flake";
      };
    };

  outputs = { home-manager, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      ZeNixLaptop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              inputs.hm-nvim-traxys.overlay."${system}"
              (import inputs.nixpkgs-mozilla)
            ];
          })
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.traxys = { config, lib, pkgs, ... }: {
              imports = [
                ./home.nix
                inputs.zsh-traxys.home-managerModule."${system}"
				inputs.hm-nvim-traxys.home-managerModule."${system}"
              ];
            };
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
