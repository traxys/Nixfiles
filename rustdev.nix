{
  config,
  pkgs,
  lib,
  ...
}: {
  home.sessionVariables = {
    RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
  };

  home.packages = with pkgs; [
    pkgs.rust-bin.stable.latest.default
    cargo-edit
  ];

  home.file = {
	".zfunc/_cargo".text = ''
  		#compdef cargo
    	source $(rustc --print sysroot)/share/zsh/site-functions/_cargo
	'';
  };
}
