{
  lib,
  upstream,
  nvim-treesitter,
  neovimUtils,
  nurl,
  python3,
  wrapNeovimUnstable,
  stdenv,
  makeWrapper,
}: let
  neovimTs =
    (neovimUtils.override {
      neovim-unwrapped = upstream;
    })
    .makeNeovimConfig {
      plugins = [nvim-treesitter];
    };
in
  stdenv.mkDerivation {
    name = "update-nvim-treesitter";
    src = ./update.py;

    nativeBuildInputs = [makeWrapper];

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      cat $src > $out/bin/update-nvim-treesitter
      chmod +x $out/bin/update-nvim-treesitter
      wrapProgram $out/bin/update-nvim-treesitter --set NVIM_TREESITTER "${nvim-treesitter}" --prefix PATH : ${
        lib.makeBinPath [
          (wrapNeovimUnstable upstream neovimTs)
          nurl
          python3
        ]
      }
    '';
  }
