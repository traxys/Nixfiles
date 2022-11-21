# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  jira-cli = {
    pname = "jira-cli";
    version = "v1.1.0";
    src = fetchurl {
      url = "https://github.com/ankitpokhrel/jira-cli/archive/refs/tags/v1.1.0.tar.gz";
      sha256 = "sha256-wHbTwmNhmk+O+qoG38nLTHCaEGUjwE3QVnE3EUl8vm8=";
    };
  };
  proton-ge = {
    pname = "proton-ge";
    version = "GE-Proton7-41";
    src = fetchurl {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-41/GE-Proton7-41.tar.gz";
      sha256 = "sha256-EPV1d7X5KYV2wZWOzW1JujxBSopvuzwIoY1+mXoswVU=";
    };
  };
}