{
  naersk,
  kabalist-src,
}:
naersk.buildPackage {
  cargoBuildOptions = opts: opts ++ ["--package=kabalist_cli"];
  root = kabalist-src;
}
