{ config, lib, ... }:
let
  dotfiles = config.lib.file.mkOutOfStoreSymlink ../.dotfiles;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # started with uwsm
    extraConfig = lib.fileContents "${dotfiles}/hypr/hyprland.conf";
  };

  xdg.configFile = {
    "hypr".source = "${dotfiles}/hypr";
    "hypr/hyprland.conf".enable = false;
  };
}
