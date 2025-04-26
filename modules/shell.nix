{ ... }:

{
  programs.bash = {
    shellInit = ''
      eval "($starship init bash)"
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[\$](green)";
        error_symbol = "[\$](red)";
      };
    };
  };
}
