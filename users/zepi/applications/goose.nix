{
  pkgs,
  mkDotfiles,
  ...
}:
{
  home.packages = with pkgs; [
    goose-cli
  ];

  xdg.configFile = {
    "goose".source = mkDotfiles "goose";
  };
}
