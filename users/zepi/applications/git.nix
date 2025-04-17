{...}: 

{
  programs.git = {
    enable = true;
    extraConfig = {
      user = {
        name = "Noah Zepner";
      };
      pull.rebase = true;
    };
  };
}
