{ pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
  };

  xdg.configFile."gtk-4.0/gtk.css".force = true;
}
