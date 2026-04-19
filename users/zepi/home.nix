{
  config,
  lib,
  pkgs,
  ...
}: {
  _module.args = let
    dotfiles = "${config.home.homeDirectory}/.dotfiles";
    # Safe content reader with helpful fallback
    # Returns placeholder content if file doesn't exist
    readDotfilesImpl = subpath: let
      target = "${dotfiles}/${subpath}";
      relativePath = builtins.concatStringsSep "/" (lib.splitString "/" subpath);
    in
      if builtins.pathExists target
      then builtins.readFile target
      else ''
        # Configuration not available: ${relativePath}
        # 
        # This file appears to be missing from your dotfiles repository.
        # Expected location: ${target}
        # 
        # To resolve:
        # 1. Clone dotfiles: git clone git@github.com:zepi2509/dotfiles.git ~/.dotfiles
        # 2. Or create the file: touch ${target}
        # 3. Then rebuild: sudo nixos-rebuild switch --flake .
      '';
  in {
    # Path to dotfiles (for in-store copies)
    mkDotfiles = subpath: "${dotfiles}/${subpath}";

    # Symlink outside store (for live editing)
    mkDotfilesOutOfStore = subpath: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${subpath}";

    # Safe content reader - use for plain text files
    readDotfiles = readDotfilesImpl;

    # Safe reader for TOML files with graceful fallback
    readDotfilesAsTOML = subpath: let
      target = "${dotfiles}/${subpath}";
      content = readDotfilesImpl subpath;
    in
      if builtins.pathExists target
      then builtins.fromTOML content
      else {}; # Return empty config if file doesn't exist

    # Safe reader for JSON files with graceful fallback
    readDotfilesAsJSON = subpath: let
      target = "${dotfiles}/${subpath}";
      content = readDotfilesImpl subpath;
    in
      if builtins.pathExists target
      then builtins.fromJSON content
      else {}; # Return empty config if file doesn't exist
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
      # This activation script is deprecated. See home.file configuration below.
    '';

    # Declarative symlink management for OneDrive directories
    # Using Home Manager's file system for better reproducibility
    file."Documents".source = config.lib.mkIf (builtins.pathExists "/home/zepi/.onedrive/Documents")
      (config.lib.file.mkOutOfStoreSymlink "/home/zepi/.onedrive/Documents");
    file."Downloads".source = config.lib.mkIf (builtins.pathExists "/home/zepi/.onedrive/Downloads")
      (config.lib.file.mkOutOfStoreSymlink "/home/zepi/.onedrive/Downloads");
    file."Images".source = config.lib.mkIf (builtins.pathExists "/home/zepi/.onedrive/Images")
      (config.lib.file.mkOutOfStoreSymlink "/home/zepi/.onedrive/Images");
    file."Videos".source = config.lib.mkIf (builtins.pathExists "/home/zepi/.onedrive/Videos")
      (config.lib.file.mkOutOfStoreSymlink "/home/zepi/.onedrive/Videos");
    file."Musik".source = config.lib.mkIf (builtins.pathExists "/home/zepi/.onedrive/Musik")
      (config.lib.file.mkOutOfStoreSymlink "/home/zepi/.onedrive/Musik");

    sessionVariables = {
      BROWSER = "zen";
    };

    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
