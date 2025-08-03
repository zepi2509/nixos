{ inputs, system, pkgs, ... }:
{
  imports = [
    ./caelestia
    ./stylix.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./backlight.nix
    ./steam.nix
    ./fonts.nix
  ];

  environment.systemPackages = with pkgs; [
    ghostty
    inputs.zen-browser.packages."${system}".default
    chromium
    rofi-wayland
    impala
  ];
}
