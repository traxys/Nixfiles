{ vim-headerguard }:
{
  imports = [
    ./diagram-nvim.nix
    (import ./headerguard.nix { inherit vim-headerguard; })
    ./lsp-signature.nix
  ];
}
