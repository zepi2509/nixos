{...}: {
  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = ["zen-browser.desktop"];
      "x-scheme-handler/http" = ["zen-browser.desktop"];
      "x-scheme-handler/https" = ["zen-browser.desktop"];
      "x-scheme-handler/about" = ["zen-browser.desktop"];
      "x-scheme-handler/unknown" = ["zen-browser.desktop"];
    };
  };
}
