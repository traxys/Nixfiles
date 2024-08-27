{ lua, runCommand }:
runCommand "wow-note" { buildInputs = [ lua ]; } ''
  mkdir -p $out/bin
  cat ${./wow_note.lua}> $out/bin/wow-note
  chmod +x $out/bin/wow-note
  patchShebangs --host $out/bin/wow-note
''
