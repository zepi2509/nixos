{
  config,
  pkgs,
  mkDotfilesOutOfStore,
  ...
}:
{
  home.packages = with pkgs; [
    goose-cli
  ];

  xdg.configFile = {
    "goose".source = mkDotfilesOutOfStore "goose";
  };
}
