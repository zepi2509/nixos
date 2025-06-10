final: prev: 
{
  onedrive = prev.onedrive.overrideAttrs (oldAttrs: rec { 
    version = "2.5.6";

    src = prev.fetchFromGitHub {
      owner = "abraunegg";
      repo = "onedrive";
      rev = "v${version}";
      hash = "sha256-AFaz1RkrtsdTZfaWobdcADbzsAhbdCzJPkQX6Pa7hN8=";
    };

    buildInputs = oldAttrs.buildInputs ++ [ prev.dbus ];
  });
}
