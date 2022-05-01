{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kmod,
  name,
  ...
}: let
  anbox-modules = fetchFromGitHub {
    owner = "choff";
    repo = "anbox-modules";
    rev = "8148a162755bf5500a07cf41a65a02c8f3eb0af9";
    sha256 = "sha256-5YeKwLP0qdtmWbL6AXluyTmVcmKJJOFcZJ5NxXSSgok=";
  };
in
  stdenv.mkDerivation rec {
    inherit name;
    version = "0";

    src = "${anbox-modules}/${name}";

    #sourceRoot = "${src}/${ashmem}";
    hardeningDisable = ["pic" "format"];
    nativeBuildInputs = kernel.moduleBuildDependencies;

    KERNEL_SRC = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

    buildPhase = "make INSTALL_MOD_PATH=$out";
    installPhase = ''
          modDir=$out/lib/modules/${kernel.modDirVersion}/kernel/updates/
      mkdir -p $modDir
      mv ${name}_linux.ko $modDir/.
    '';

    /*
      makeFlags = [
     "KERNELRELEASE=${kernel.modDirVersion}"
     "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
     "INSTALL_MOD_PATH=$(out)"
     ];
     */

    meta = with lib; {
      description = "Kernel module for anbox - ${name}";
      homepage = "https://github.com/choff/anbox-modules";
      license = licenses.gpl2;
      maintainers = [];
      platforms = platforms.linux;
    };
  }
