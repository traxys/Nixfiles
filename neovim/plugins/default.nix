{ vim-headerguard }:
{
  imports = [
    (import ./headerguard.nix { inherit vim-headerguard; })
  ];
}
