{ ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        # grace = 300;
        hide_cursor = true;
        ignore_empty_input = true;
      };

      background = [
        {
          path = "~/.nixos/users/zepi/wallpapers/black-and-white-river.jpg";
          blur_passes = 2;
          blur_size = 5;
        }
      ];

      input-field = [
        {
          position = "0, 50";
          halign = "center";
          valign = "bottom";
          size = "250, 30";
          outline_thickness = 1;
          rounding = 5;
          
          # dots
          dots_center = true;
          dots_spacing = 0.5;

          # colors
          outer_color = "rgb(ffffff00)";
          inner_color = "rgb(000000)";
          font_color = "rgb(ffffff)";
          fail_color = "rgb(00000000)";
          check_color = "rgb(ffffff)";

          # text
          placeholder_text = "";
          fail_text = "";
        }
      ];
    };
  };
}
