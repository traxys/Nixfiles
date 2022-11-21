{
  jira-src,
  buildGoModule,
}:
buildGoModule {
  inherit (jira-src) pname src version;

  vendorSha256 = "sha256-SpUggA9u8OGV2zF3EQ0CB8M6jpiVQi957UGaN+foEuk=";

  doInstallCheck = false;
  doCheck = false;
}
