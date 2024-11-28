{lib, ...}: let 
  inherit (import ../../str-obf.nix lib) decode;
  workDomain = "lenmlx.ziy";
in {
  extraInfo.email = "quentin.boyer@${decode workDomain}";

  extraInfo.username = "traxys";

  extraInfo.inputs.touchpad = "2:7:SynPS/2_Synaptics_TouchPad";
}
