{ pkgs, ... }:
{
  home.packages = with pkgs; [
    plasma5Packages.kdeconnect-kde
    kdePackages.kdenlive
    glaurung
    anki-bin
  ];
}
