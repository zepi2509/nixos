{
  inputs,
  config,
  lib,
  ...
}:
let
  dotfiles = config.lib.file.mkOutOfStoreSymlink ../.dotfiles;
in
{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
      environment = [ ];
    };
    cli = {
      enable = true;
    };
    extraConfig = lib.fileContents "${dotfiles}/caelestia/shell.json";
  };
}
