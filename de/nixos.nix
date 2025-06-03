{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ playerctl ];

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
}
