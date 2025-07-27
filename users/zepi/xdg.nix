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
      jetbains-toolbox = {
        name = "JetBrains Toolbox";
        exec = "jetbrains-toolbox";
        terminal = false;
        categories = [ "Development" "IDE" ];
      };
    };

    mime.enable = true;
  };
}
