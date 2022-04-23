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
	  nix-alien.url = "github:thiagokokada/nix-alien";
	  nix-ld.url = "github:Mic92/nix-ld/main";
      nvim-traxys = {
        url = "github:traxys/nvim-flake";
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
              inputs.nvim-traxys.overlay."${system}"
			  inputs.nix-alien.overlay
              (import inputs.nixpkgs-mozilla)
              (final: prev: {
              })
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
                ./graphical.nix
                ./extra_info.nix
                ./localinfo.nix
                ./wm
                ./rustdev.nix
                ./git
                inputs.zsh-traxys.home-managerModule."${system}"
                inputs.nvim-traxys.home-managerModule."${system}"
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
