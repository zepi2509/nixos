# This file is used to set top level configurations, that apply to all hosts
{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./overlays.nix
    ./shell
  ];

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
    substituters = [
      "https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  # Restrict unfree packages to only those explicitly needed
  # This helps prevent accidentally pulling in proprietary software
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # Fonts
      "corefonts" # Microsoft core fonts (Arial, Times New Roman, etc.)
      "helvetica-neue-lt-std" # Helvetica Neue font (proprietary)
      "noto-fonts" # Google Noto fonts (includes CJK support)

      # Browsers and multimedia
      "zen-browser" # Zen Browser

      # Development tools
      "jetbrains-toolbox" # JetBrains IDE launcher

      # Communication and media
      "spotify" # Music streaming service
      "zoom" # Zoom video conferencing (package name is 'zoom', not 'zoom-us')
      "signal-desktop" # Secure messaging

      # Utilities
      "ausweisapp" # German ID card reader (government software)
      "obsidian" # Note-taking application
      "zotero" # Reference manager
      "darktable" # Photo RAW processor
    ];

  customization.overlays.enable = true;

  programs = {
    nix-ld = {
      enable = true;
      libraries = [];
    };
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 5d --keep 3";
      };
      flake = "/home/zepi/.nixos";
    };
  };

  environment.sessionVariables = {
    FLAKE = "/home/zepi/.nixos";
  };

  # Global packages
  environment.systemPackages = with pkgs; [
    wl-clipboard # Wayland clipboard management
    htop # Interactive process viewer
  ];
}
