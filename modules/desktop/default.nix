{ inputs, system, pkgs, ... }:
{
  imports = [
    ./stylix.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hypridle.nix
    # ./notifcations.nix
    ./backlight.nix
  ];

  environment.systemPackages = with pkgs; [
    ghostty
    inputs.zen-browser.packages."${system}".twilight
    chromium
    rofi-wayland
    dunst
  ];
}
