{
  config,
  pkgs,
  mkDotfilesOutOfStore,
  ...
}:
{
  home.packages = with pkgs; [
    goose-cli
    uv
    nodejs
  ];

  xdg.configFile = {
    "goose".source = mkDotfilesOutOfStore "goose";
    "agents".source = mkDotfilesOutOfStore "agents";
  };
}
