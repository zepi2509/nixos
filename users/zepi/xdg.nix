{ config, lib, ... }:

{
  xdg = {
    enable = true;

    desktopEntries = {
      # zen = {
      #   name = "Zen Browser";
      #   genericName = "Web Browser";
      #   exec = "zen-browser %U";
      #   terminal = false;
      #   categories = [ "Network" "WebBrowser" ];
      #   mimeType = [ "text/html" "text/xml" "x-scheme-handler/http" "x-scheme-handler/https" ];
      # };
    };

    mime.enable = true;
  };
}
