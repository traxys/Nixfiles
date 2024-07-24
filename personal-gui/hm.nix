{ pkgs, ... }:
{
  home.packages = with pkgs; [
    plasma5Packages.kdeconnect-kde
    glaurung
  ];
}
