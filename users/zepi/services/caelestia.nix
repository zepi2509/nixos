{
  inputs,
  config,
  lib,
  mkDotfiles,
  ...
}:
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
    extraConfig = lib.fileContents (mkDotfiles "caelestia/shell.json");
  };
}
