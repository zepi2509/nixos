{
  pkgs,
  readDotfiles,
  mkDotfiles,
  ...
}: {
  home.packages = with pkgs; [
    tinymist
    nixd
    alejandra
    taplo
  ];

  programs.helix = {
    enable = true;
    settings = fromTOML (readDotfiles "helix/config.toml");
    languages = fromTOML (readDotfiles "helix/languages.toml");
  };
}
