{ pkgs, ... }:
{
  home.packages = with pkgs; [
    plasma5Packages.kdeconnect-kde
    kdePackages.kdenlive
    glaurung
    nur.repos.xeals.cura5
    anki-bin
  ];
}
