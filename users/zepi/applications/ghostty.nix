{ ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      cursor-style = "underline";
      shell-integration-features = "no-cursor";

      gtk-tabs-location = "left";

      window-padding-x = "15";
      window-padding-y = "15";
      window-padding-balance = "true";
      window-padding-color = "extend";

      keybind = [
      ];
    };
  };
}
