{
  pkgs,
  readDotfiles,
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
    defaultEditor = true;
    settings = fromTOML (readDotfiles "helix/config.toml");
    languages = fromTOML (readDotfiles "helix/languages.toml");
  };
}
