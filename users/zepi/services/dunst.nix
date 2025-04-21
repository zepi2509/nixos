{ lib, config, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        corner_radius = 5;
      };

      urgency_low = {
        frame_color = lib.mkForce "rgb(${config.lib.stylix.colors.withHashtag.base03})";
      };

      urgency_normal = {
        frame_color = lib.mkForce "rgb(${config.lib.stylix.colors.withHashtag.base07})";
      };
    };
  };

}
