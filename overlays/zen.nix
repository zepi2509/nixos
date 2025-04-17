final: prev:
{
  zen-browser = final.appimageTools.wrapType2 {
    pname = "zen-browser";
    version = "latest";

    src = final.fetchurl {
      url = "https://github.com/zen-browser/desktop/releases/latest/download/zen-x86_64.AppImage";
      sha256 = "sha256-Ub7sQEP9W8kD311/UOkzdZ1DJ4qjgBXyJmndLiA4Vl4=";
    };
  };
}
