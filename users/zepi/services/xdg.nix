{mkDotfilesOutOfStore, ...}: {
  xdg = {
    enable = true;

    desktopEntries = {
      superhuman = {
        name = "Superhuman";
        genericName = "Email";
        exec = "chromium --app=https://mail.superhuman.com/";
        icon = ../.icons/superhuman-mail.png;
        terminal = false;
        categories = [
          "Network"
          "Office"
          "Email"
        ];
      };
    };

    mime.enable = true;

    configFile = {
      "qt6ct/qt6ct.conf".force = true;
      "qt5ct/qt5ct.conf".force = true;
      "gtk-4.0/gtk.css".force = true;
      "gtk-3.0/gtk.css".force = true;
      ".ideavimrc".source = mkDotfilesOutOfStore ".ideavimrc";
      "nix/nix.conf".source = mkDotfilesOutOfStore "nix/nix.conf";
    };
  };
}
