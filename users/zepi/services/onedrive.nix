{mkDotfilesOutOfStore, ...}: {
  programs.onedrive = {
    enable = true;
  };

  xdg.configFile = {
    "onedrive".source = mkDotfilesOutOfStore "onedrive";
  };
}
