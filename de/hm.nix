{ pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
  };

  programs.foot.settings.main.pad = "0x0x0x8";

  xdg.configFile."gtk-4.0/gtk.css".force = true;
}
