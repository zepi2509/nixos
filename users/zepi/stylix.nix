{ pkgs, ... }:

{
  stylix = {
    image = ./.wallpapers/black-and-white-river.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";
    polarity = "dark";
    opacity = {
      applications = 0.8;
      desktop = 0.8;
      popups = 0.8;
      terminal = 0.8;
    };

    iconTheme = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      light = "Adwaita";
      dark = "Adwaita";
    };
  };

}
