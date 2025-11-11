{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprpaper
  ];

  services.hyprpaper = {
    enable = false;

    settings = {
      ipc = "off";
      splash = false;

      preload = [ 
        "~/.nixos/users/zepi/wallpapers/black-and-white-river.jpg"
      ];

      wallpaper = [
        ",~/.nixos/users/zepi/wallpapers/black-and-white-river.jpg"
      ];
    };
  };
}
