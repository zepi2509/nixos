{ config, mkDotfilesOutOfStore, ... }:
{
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
      ".ideavimrc".source = mkDotfilesOutOfStore ".ideavimrc";
    };
  };
}
