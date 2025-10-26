{...}: 

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Noah Zepner";
      };
      pull.rebase = true;
    };
  };
}
