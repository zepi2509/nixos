{ config, pkgs, ... }:
{
  _module.args = {
    mkDotfiles =
      subpath:
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/users/zepi/.dotfiles/${subpath}";

  };

  imports = [
    ./services
    ./applications
  ];

  home = {
    username = "zepi";
    homeDirectory = "/home/zepi";

    activation.linkMyFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      # onedrive
      if [ -e "/home/zepi/.onedrive" ]; then
        ln -sf "/home/zepi/.onedrive/Documents" "/home/zepi"
        ln -sf "/home/zepi/.onedrive/Images" "/home/zepi"
        ln -sf "/home/zepi/.onedrive/Videos" "/home/zepi"
        ln -sf "/home/zepi/.onedrive/Musik" "/home/zepi"
      fi

      # wallpapers
      rm -rf /home/zepi/Images/Wallpaper/nixos/
      mkdir -p /home/zepi/Images/Wallpaper/nixos/
      cp -r /home/zepi/.nixos/users/zepi/.wallpapers/* /home/zepi/Images/Wallpaper/nixos/
    '';

    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
