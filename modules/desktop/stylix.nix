{ inputs, pkgs, ... }:

{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark-dark.yaml";

    override = {
      # Syntax Accents
      base08 = "d4a4a4"; # $red
      base09 = "c79c74"; # $orange
      base0A = "c1c4ca"; # $gray (Often used for specific UI/Yellow roles)
      base0B = "9aaf8b"; # $green
      base0C = "83b2b6"; # $cyan
      base0D = "779dc9"; # $blue
      base0E = "b6addb"; # $purple

      # Foreground/Text
      base05 = "c1c4ca"; # $gray

      # Optional: Handling the "illegal-red" or "interpolation"
      # Usually mapped to base0F in Base16 for special markup
      base0F = "b87777";
    };

    polarity = "dark";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      emoji = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
    };

    icons = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      light = "Adwaita";
      dark = "Adwaita";
    };

    targets = {
      grub.enable = false;
      plymouth.enable = false;
    };
  };
}
