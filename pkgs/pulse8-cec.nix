{
  stdenv,
  lib,
  linuxPackages,
  kernel ? linuxPackages.kernel,
}:
stdenv.mkDerivation {
  pname = "pulse8-cec-module";
  inherit (kernel)
    src
    version
    postPatch
    nativeBuildInputs
    ;

  kernel_dev = kernel.dev;
  kernelVersion = kernel.modDirVersion;

  modulePath = "drivers/media/cec/usb/pulse8";

  buildPhase = ''
    BUILT_KERNEL=$kernel_dev/lib/modules/$kernelVersion/build

    cp $BUILT_KERNEL/Module.symvers .
    cat $BUILT_KERNEL/.config >.config
    cp $kernel_dev/vmlinux .

    ./scripts/config --enable CONFIG_MEDIA_CEC_SUPPORT
    ./scripts/config --module CONFIG_USB_PULSE8_CEC

    make "-j$NIX_BUILD_CORES" modules_prepare
    make "-j$NIX_BUILD_CORES" M=$modulePath modules
  '';

  installPhase = ''
    make \
      INSTALL_MOD_PATH="$out" \
      XZ="xz -T$NIX_BUILD_CORES" \
      M="$modulePath" \
      modules_install
  '';

  meta = {
    description = "Pulse 8 CEC kernel module";
    license = lib.licenses.gpl2;
  };

}
