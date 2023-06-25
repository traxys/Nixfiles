{
  config,
  pkgs,
  ...
}: {
  home.username = "${config.extraInfo.username}";
  home.homeDirectory = "/home/${config.extraInfo.username}";
  home.packages = with pkgs; [cura];

  programs.git = {
    userName = "traxys";
    userEmail = config.extraInfo.email;
  };

  wm.startup = [
    {command = "${pkgs.wayvnc}/bin/waync 127.0.0.1 5800";}
    {command = "${pkgs.ckb-next}/bin/ckb-next -b";}
  ];

  wm.workspaces.definitions = {
    "2:".output = "HDMI-A-1";
    "".output = "DP-2";
    "".output = "DP-2";
  };

  services.mako.output = "DP-2";

  xdg.desktopEntries.teams = {
  	name = "teams";
	exec = "${pkgs.chromium}/bin/chromium --app=https://teams.microsoft.com";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
}
