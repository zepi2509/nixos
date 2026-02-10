# This file is used to set top level configurations, that apply to all hosts
{pkgs, ...}: {
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

  nixpkgs.config.allowUnfree = true;

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
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
  };

  environment.sessionVariables = {
    FLAKE = "/home/zepi/.nixos";
  };

  # Global packages
  environment.systemPackages = with pkgs; [
    wl-clipboard
    htop
  ];
}
