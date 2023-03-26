{pkgs, ...}: {
  home.packages = with pkgs; [
  ];

  /*
   environment.pathsToLink = [ "/share/hunspell" "/share/myspell" "/share/hyphen" ];
  environment.variables.DICPATH = "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";
  */
}
