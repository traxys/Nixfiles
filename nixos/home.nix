{ ... }:

{
  imports = [
    <home-manager/nixos>
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.users.traxys = (import /etc/nixos/traxys/home.nix);
}
