{
  lib,
  phonto,
  writeShellScriptBin,
}:
writeShellScriptBin "phonto-slideshow" ''
  prev=

  kill_prev() {
  	if [[ -n $prev ]]; then
  		kill "$prev"
  	fi

  	prev=
  }

  trap kill_prev EXIT

  while true; do
    ${lib.getExe phonto} --rand --pause-below 30 &
    sleep 0.1

    kill_prev
    prev=$cur
    sleep 1h
  done
''
