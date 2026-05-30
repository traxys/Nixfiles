{ vim-headerguard, fcitx }:
{
  imports = [
    (import ./headerguard.nix { inherit vim-headerguard; })
    (import ./fcitx.nix { inherit fcitx; })
  ];
}
