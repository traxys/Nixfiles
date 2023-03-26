{
  config,
  pkgs,
  ...
}: {
  /*
   services.xserver = {
     enable = true;
     videoDrivers = [ "nvidia" ];
  layout = "us";
  xkbVariant = "dvp";
  libinput.enable = true;
     desktopManager.session = [
       {
         name = "home-manager";
         start = ''
  		${pkgs.runtimeShell} $HOME/.hm-xsession-dbg&
  		waitPID=$!
  	'';
       }
     ];
   };
  */

  users = {
    users = {
      traxys = {
        extraGroups = [
          "wheel"
          "http"
        ];
      };
    };
  };

  # Set your time zone.
  # time.timeZone = "Europe/Paris";
}
