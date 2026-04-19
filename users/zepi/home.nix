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
    in
      if builtins.pathExists target
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
      DOTFILES_DIR="$HOME/.dotfiles"
      DOTFILES_REPO="git@github.com:zepi2509/dotfiles.git"

      if [ ! -d "$DOTFILES_DIR" ]; then
        echo "Cloning dotfiles repository..."
        
        # Ensure SSH known_hosts has GitHub's key to prevent MITM attacks
        if ! grep -q "github.com" "$HOME/.ssh/known_hosts" 2>/dev/null; then
          echo "Adding GitHub to known_hosts..."
          mkdir -p "$HOME/.ssh"
          ${pkgs.openssh}/bin/ssh-keyscan -H github.com >> "$HOME/.ssh/known_hosts" 2>/dev/null || true
        fi
        
        # Clone with error handling
        if ${pkgs.git}/bin/git clone "$DOTFILES_REPO" "$DOTFILES_DIR" 2>/dev/null; then
          echo "✓ Dotfiles cloned successfully"
        else
          echo "✗ Failed to clone dotfiles from $DOTFILES_REPO"
          echo "Make sure:"
          echo "  1. SSH key is configured and loaded: ssh-add ~/.ssh/github_key"
          echo "  2. You have access to the repository"
          echo "  3. SSH connection to GitHub is working: ssh -T git@github.com"
          exit 1
        fi
      fi
    '';

    activation.linkMyFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
      # onedrive
      if [ -e "/home/zepi/.onedrive" ]; then
        ln -sf "/home/zepi/.onedrive/Documents" "/home/zepi"
        ln -sf "/home/zepi/.onedrive/Downloads" "/home/zepi"
        ln -sf "/home/zepi/.onedrive/Images" "/home/zepi"
        ln -sf "/home/zepi/.onedrive/Videos" "/home/zepi"
        ln -sf "/home/zepi/.onedrive/Musik" "/home/zepi"
      fi

      # wallpapers
      # rm -rf /home/zepi/Images/Wallpaper/nixos/
      # mkdir -p /home/zepi/Images/Wallpaper/nixos/
      # cp -r /home/zepi/.nixos/users/zepi/.wallpapers/* /home/zepi/Images/Wallpaper/nixos/
    '';

    sessionVariables = {
      BROWSER = "zen";
    };

    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
