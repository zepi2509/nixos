{ inputs, pkgs, ... }:
{
  imports = [
    ./stylix.nix
    ./hyprland.nix
    ./hypridle.nix
    ./backlight.nix
    ./steam.nix
    ./fonts.nix
  ];

  environment.systemPackages = with pkgs; [
    ghostty
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    chromium
    impala
    eog
  ];
}
