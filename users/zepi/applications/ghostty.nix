{ ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      cursor-style = "underline";
      shell-integration-features = "no-cursor";

      gtk-tabs-location = "left";

      keybind = [
      ];
    };
  };
}
