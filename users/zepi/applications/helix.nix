{
  lib,
  pkgs,
  mkDotfiles,
  ...
}: {
  home.packages = with pkgs; [
    tinymist
    nixd
    alejandra
  ];

  programs.helix = {
    enable = true;
    extraConfig = lib.fileContents (mkDotfiles "helix/config.toml");
  };

  xdg.configFile = {
    "helix/languages.toml".source = mkDotfiles "helix/languages.toml";
  };
}
