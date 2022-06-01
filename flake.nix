{
  description = "NixOS configuration";

  inputs = {
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
    xdg-ninja = {
      url = "github:traxys/xdg-ninja";
      flake = false;
    };
  };

  outputs = {
    home-manager,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations = {
      ZeNixLaptop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ({pkgs, ...}: {
            nixpkgs.overlays = [
              inputs.nvim-traxys.overlay."${system}"
              inputs.nix-alien.overlay
              (import inputs.nixpkgs-mozilla)
              (final: prev: {
                xdg-ninja = with pkgs;
                  stdenv.mkDerivation rec {
                    pname = "xdg-ninja";
                    version = "0.1";
                    src = inputs.xdg-ninja;
                    installPhase = ''
                      mkdir -p $out/bin
                      cp xdg-ninja.sh $out/bin
                      cp -r programs $out/bin
                      wrapProgram $out/bin/xdg-ninja.sh \
                      	--prefix PATH : ${lib.makeBinPath [bash jq glow]}
                    '';
                    buildInputs = [jq glow bash];
                    nativeBuildInputs = [makeWrapper];
                  };
              })
            ];
          })
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.traxys = {
              config,
              lib,
              pkgs,
              ...
            }: {
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
