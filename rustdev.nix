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
    rustup
    cargo-edit
  ];
}
