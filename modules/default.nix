# This file is used to set top level configurations, that apply to all hosts
{ inputs, pkgs, ... }:

{
  imports = [
    ./overlays.nix
    ./shell
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    access-tokens = [ "github.com=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" ];
    auto-optimise-store = true;
  };

  nixpkgs.config.allowUnfree = true;

  customization.overlays.enable = true;

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 5d --keep 3";
    };
    flake = "/home/zepi/.nixos";
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  environment.sessionVariables = {
    FLAKE = "/home/zepi/.nixos";
  };

  # Global packages
  environment.systemPackages = with pkgs; [
    wl-clipboard
    inputs.neovim.packages."${system}".nightly
    htop
  ];
}
