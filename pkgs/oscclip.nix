{
  oscclip-src,
  poetry2nix,
  ...
}:
poetry2nix.mkPoetryApplication {
  projectDir = oscclip-src;
}
