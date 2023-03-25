{config, ...}: {
  programs.git = {
    userName = "traxys";
    userEmail = config.extraInfo.email;
  };
}
