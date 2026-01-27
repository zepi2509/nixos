{
  pkgs,
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
    settings = fromTOML (builtins.readFile (mkDotfiles "helix/config.toml"));
    languages = fromTOML (builtins.readFile (mkDotfiles "helix/languages.toml"));
  };
}
