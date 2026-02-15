{
  config,
  lib,
  pkgs,
  ...
}: {
  _module.args = let
    dotfiles = "${config.home.homeDirectory}/.dotfiles";
  in {
    # Path to dotfiles (for in-store copies)
    mkDotfiles = subpath: "${dotfiles}/${subpath}";
    
    # Symlink outside store (for live editing)
    mkDotfilesOutOfStore = subpath: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${subpath}";
    
    # Safe content reader - returns placeholder if file doesn't exist yet
    # Use this for lib.fileContents when dotfiles may not be cloned yet
    readDotfiles = subpath: let
      target = "${dotfiles}/${subpath}";
    in if builtins.pathExists target 
       then builtins.readFile target 
       else "# TODO: Clone dotfiles to ${dotfiles}\n";
  };

  imports = [
    ./services
    ./applications
  ];

  home = {
    username = "zepi";
    homeDirectory = "/home/zepi";

    activation.cloneDotfiles = lib.hm.dag.entryBefore ["writeBoundary"] ''
      if [ ! -d "$HOME/.dotfiles" ]; then
        ${pkgs.git}/bin/git clone git@github.com:zepi2509/dotfiles.git "$HOME/.dotfiles"
      fi
    '';

    activation.linkMyFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
      # onedrive
      # if [ -e "/home/zepi/.onedrive" ]; then
      #   ln -sf "/home/zepi/.onedrive/Documents" "/home/zepi"
      #   ln -sf "/home/zepi/.onedrive/Images" "/home/zepi"
      #   ln -sf "/home/zepi/.onedrive/Videos" "/home/zepi"
      #   ln -sf "/home/zepi/.onedrive/Musik" "/home/zepi"
      # fi

      # wallpapers
      # rm -rf /home/zepi/Images/Wallpaper/nixos/
      # mkdir -p /home/zepi/Images/Wallpaper/nixos/
      # cp -r /home/zepi/.nixos/users/zepi/.wallpapers/* /home/zepi/Images/Wallpaper/nixos/
    '';

    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
