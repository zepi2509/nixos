{
  config,
  lib,
  mkDotfiles,
  mkDotfilesOutOfStore,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # started with uwsm
    extraConfig = lib.fileContents (mkDotfiles "hypr/hyprland.conf");
  };

  xdg.configFile = {
    "hypr".source = mkDotfilesOutOfStore "hypr";
    "hypr/hyprland.conf".enable = false;
  };
}
