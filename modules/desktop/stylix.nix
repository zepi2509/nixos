{ inputs, pkgs, ... }:

# Stylix - Declarative theming for entire system
# Generates consistent color schemes across all applications
# Changes propagate to GTK, Qt, terminals, etc. automatically

{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;

    # Base16 color scheme - uses onedark-dark as foundation
    # Base16 provides standardized 16-color palette for consistency
    base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark-dark.yaml";

    # Color override - customize specific palette colors
    # Allows fine-tuning syntax highlighting colors
    # Base16 palette mapping:
    #   base00-07: background and foreground variants
    #   base08-0F: syntax highlighting (red, orange, yellow, etc.)
    override = {
      # Syntax Accents - customized from base scheme
      base08 = "d4a4a4"; # Red - errors, keywords, attributes
      base09 = "c79c74"; # Orange - operators, tags
      base0A = "c1c4ca"; # Gray - warnings, constants
      base0B = "9aaf8b"; # Green - strings, insertions
      base0C = "83b2b6"; # Cyan - regex, special text
      base0D = "779dc9"; # Blue - functions, types
      base0E = "b6addb"; # Purple - variables, markup
      base0F = "b87777"; # Special markup (interpolation, etc.)

      # Text color
      base05 = "c1c4ca"; # Gray text on dark backgrounds
    };

    # Use dark color variant
    polarity = "dark";

    # Cursor configuration
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24; # Adjust if hard to see on high-DPI displays
    };

    # Font configuration
    # Applied system-wide: Terminal, GTK, Qt, etc.
    fonts = {
      # Monospace for terminal, code editors
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      # Sans-serif for UI
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      # Serif for documents (less common in modern UIs)
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      # Emoji font
      emoji = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
    };

    # Icon theme configuration
    icons = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      # Use Adwaita for both light and dark (recolored by stylix)
      light = "Adwaita";
      dark = "Adwaita";
    };

    # Theme targets - enable/disable theming for specific components
    targets = {
      # GRUB (bootloader) - disabled to avoid boot issues
      grub.enable = false;
      # Plymouth (boot animation) - disabled; handled separately
      plymouth.enable = false;
    };
  };
}
