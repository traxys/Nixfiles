{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.naersk.url = "github:nix-community/naersk";
  inputs.rust-overlay.url = "github:oxalica/rust-overlay";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    naersk,
    rust-overlay,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [(import rust-overlay)];
      };
      rust = pkgs.rust-bin.stable.latest.default;
      naersk' = pkgs.callPackage naersk {
        cargo = rust;
        rustc = rust;
      };
      libPath = with pkgs; lib.makeLibraryPath [libxkbcommon wayland];
    in {
      devShell = pkgs.mkShell {
        nativeBuildInputs = [rust];
        RUST_PATH = "${rust}";
        RUST_DOC_PATH = "${rust}/share/doc/rust/html/std/index.html";
        LD_LIBRARY_PATH = libPath;
      };

      defaultPackage = naersk'.buildPackage {
        src = ./.;
        nativeBuildInputs = [pkgs.makeWrapper];
        postInstall = ''
          wrapProgram "$out/bin/todo_change_name" --prefix LD_LIBRARY_PATH : "${libPath}"
        '';
      };
    });
}

