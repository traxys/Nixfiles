{pkgs, ...}: {
  home.packages = with pkgs; [
    bear
    chromium
    clang-analyzer
    clang-tools
    cppcheck
    jira-cli-go
    libfabric
    opensc
    pcsclite
    pcsctools
    python39Packages.clustershell
    shellcheck
    shfmt
    slack
    sshfs
    teams
  ];

  wm.startup = [
    {command = "teams";}
    {command = "chromium --new-window teams.microsoft.com";}
  ];

  wm.workspaces.definitions."".assign = [
    "Microsoft Teams"
    "Chromium-browser"
  ];

  home.sessionVariables = {
    OPENSC_SO = "${pkgs.opensc}";
  };

  home.file = {
    "libs/opensc-pkcs11.so".source = "${pkgs.opensc}/lib/opensc-pkcs11.so";
    "libs/libpcsclite.so.1".source = "${pkgs.pcsclite}/lib/libpcsclite.so.1";
  };

  programs.zsh.shellAliases = {
    gemail = "git send-email --to='dl-bxi-sw-ll-patches@atos.net'";
  };
}
