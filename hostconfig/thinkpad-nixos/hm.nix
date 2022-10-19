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

  programs.zsh.shellAliases = {
    gemail = "git send-email --to='dl-bxi-sw-ll-patches@atos.net'";
  };
}
