{ config, pkgs, ... }:
  {
  imports = [
    ./stylix.nix
    ./applications
    ./services
    ./hypr/hyprpaper.nix
    ./hypr/hyprlock.nix
    ./xdg.nix
  ];

  home = {
    username = "zepi";
    homeDirectory = "/home/zepi";

    packages = with pkgs; [
      # Tools
      carapace
      yazi
      p7zip
      unzip
      ripgrep
      fd
      wget
      cliphist
      tree-sitter
      pnpm
      eyedropper
      onefetch
      typst

      # Apps
      jetbrains-toolbox
      spotify
      ausweisapp
      zathura
      nautilus
      zoom-us
      signal-desktop
      obsidian
      whatsie
      alacritty
      zotero

      # Languages
      typst
      tinymist
      zig
      cargo
      gcc
      go
      mermaid-cli
    ];

    activation.linkMyFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
      # hypr
      ln -sf "/home/zepi/.nixos/users/zepi/hypr/hyprland.conf" "/home/zepi/.config/hypr"
      ln -sf "/home/zepi/.nixos/users/zepi/hypr/land" "/home/zepi/.config/hypr"

      # nvim
      ln -sf "/home/zepi/.nixos/users/zepi/nvim" "/home/zepi/.config"

      # ideavim
      ln -sf "/home/zepi/.nixos/users/zepi/idea/.ideavimrc" "/home/zepi/"

      # calestia
      mkdir -p "/home/zepi/.config/caelestia/"
      ln -sf "/home/zepi/.nixos/modules/desktop/caelestia/config.json" "/home/zepi/.config/caelestia/shell.json"


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
      cp -r /home/zepi/.nixos/users/zepi/wallpapers/* /home/zepi/Images/Wallpaper/nixos/
    '';


    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}
