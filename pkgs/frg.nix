{
  stdenv,
  writeText,
  fzf,
  ripgrep,
  bat,
}:
stdenv.mkDerivation {
  pname = "frg";
  version = "0.1.0";

  dontUnpack = true;

  installPhase = let
    script = writeText "frg" ''
      #!/usr/bin/env bash

      # 1. Search for text in files using Ripgrep
      # 2. Interactively restart Ripgrep with reload action
      # 3. Open the file in Vim
      RG_PREFIX="${ripgrep}/bin/rg --column --line-number --no-heading --color=always --smart-case "
      INITIAL_QUERY="''${*:-}"
      FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY")" \
      ${fzf}/bin/fzf --ansi \
          --disabled --query "$INITIAL_QUERY" \
          --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
          --delimiter : \
          --preview '${bat}/bin/bat --color=always {1} --highlight-line {2}' \
          --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
          --bind "enter:become($EDITOR {1} +{2})"
    '';
  in ''
  	mkdir -p $out/bin
    cp ${script} $out/bin/frg
	chmod +x $out/bin/frg
  '';
}
