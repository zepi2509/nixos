{ ... }:

{
  xdg = {
    enable = true;

    desktopEntries = {
      superhuman = {
        name = "Superhuman";
        genericName = "Email";
        exec = "chromium --app=https://mail.superhuman.com/";
        terminal = false;
        categories = [ "Network" "Office" "Email" ];
      };
    };

    mime.enable = true;
  };
}
