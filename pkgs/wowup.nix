{
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 {
  name = "wowup";
  src = fetchurl {
    url = "https://github.com/WowUp/WowUp.CF/releases/download/v2.9.2-beta.3/WowUp-CF-2.9.2-beta.3.AppImage";
    sha256 = "sha256-iijulvH4yjU9vQOyQ0vCBYLR93GGL9Ak/SmVPB+ZDvY=";
  };
}
