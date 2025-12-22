{ config, lib, mkDotfiles, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # started with uwsm
    extraConfig = lib.fileContents (mkDotfiles "hypr/hyprland.conf");
  };

  xdg.configFile = {
    "hypr".source = mkDotfiles "hypr";
    "hypr/hyprland.conf".enable = false;
  };
}
