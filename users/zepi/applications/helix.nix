{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tinymist
    nixd
    alejandra
  ];

  programs.helix = {
    enable = true;
    languages = {
      language = [{
        name = "nix";
        auto-format = true;
        formatter = { command = "alejandra"; };
      }];
    };
  };
}
